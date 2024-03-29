use axum::{
    extract::Query,
    response::IntoResponse,
    routing::get,
    Extension,
    Router,
};
use oauth2::{
    basic::BasicClient,
    reqwest::async_http_client,
    AuthUrl,
    AuthorizationCode,
    ClientId,
    CsrfToken,
    PkceCodeChallenge,
    PkceCodeVerifier,
    RedirectUrl,
    Scope,
    TokenResponse,
    TokenUrl,
};
use serde::Deserialize;
use std::{
    env,
    net::SocketAddr,
    sync::Arc,
};
use tauri::Manager;
use tokio::sync::broadcast;



#[derive(Clone)]
pub struct AuthState {
    pub csrf_token: CsrfToken,
    pub pkce: Arc<(PkceCodeChallenge, String)>,
    pub client: Arc<BasicClient>,
    pub socket_addr: SocketAddr,
    pub token_sender: broadcast::Sender<String>,
}

#[derive(Deserialize)]
struct CallbackQuery {
    code: AuthorizationCode,
    state: CsrfToken,
}


#[tauri::command]
pub async fn authenticate(handle: tauri::AppHandle) -> String {
    let auth = handle.state::<AuthState>();

    // The 2nd element is the csrf token.
    // We already have it so we don't care about it.
    let (auth_url, _) = auth
        .client
        .authorize_url(|| auth.csrf_token.clone())
        .add_scope(Scope::new("user.read".to_string()))
        .set_pkce_challenge(auth.pkce.0.clone())
        .url();

    let mut token_receiver = auth.token_sender.subscribe();

    let server_handle = tauri::async_runtime::spawn(async move { run_server(handle).await });

    open::that(auth_url.to_string()).unwrap();

    // Receive the token from the broadcast channel
    let token = token_receiver.recv().await.unwrap();
    server_handle.abort();
    
    token

}

pub fn create_client(redirect_url: RedirectUrl) -> BasicClient {
    let client_id = ClientId::new(env::var("OAUTH2_CLIENT_ID").expect("OAUTH2_CLIENT_ID must be set"));
    let auth_url = AuthUrl::new(env::var("OAUTH2_AUTH_URL").expect("OAUTH2_AUTH_URL must be set"));
    let token_url = TokenUrl::new(env::var("OAUTH2_TOKEN_URL").expect("OAUTH2_TOKEN_URL must be set"));

    BasicClient::new(client_id, None, auth_url.unwrap(), token_url.ok())
        .set_redirect_uri(redirect_url)
}

async fn run_server(handle: tauri::AppHandle) -> Result<(), axum::Error> {
    let app = Router::new()
        .route("/callback", get(authorize))
        .layer(Extension(handle.clone()));

    let _ = axum::Server::bind(&handle.state::<AuthState>().socket_addr.clone())
        .serve(app.into_make_service())
        .await;

    Ok(())
}

async fn authorize(
    handle: Extension<tauri::AppHandle>,
    query: Query<CallbackQuery>,
) -> impl IntoResponse {
    let auth = handle.state::<AuthState>();

    if query.state.secret() != auth.csrf_token.secret() {
        println!("Suspected Man in the Middle attack!");
        return "authorized".to_string(); // never let them know your next move
    }

    let token = auth
        .client
        .exchange_code(query.code.clone())
        .set_pkce_verifier(PkceCodeVerifier::new(auth.pkce.1.clone()))
        .request_async(async_http_client)
        .await
        .unwrap();

    // Send the token to the broadcast channel
    let _ = auth.token_sender.send(token.access_token().secret().to_string());
    
    "authorized".to_string()
}