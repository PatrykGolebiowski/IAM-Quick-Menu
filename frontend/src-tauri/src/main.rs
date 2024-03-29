// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use dotenv::dotenv;
use oauth2::{CsrfToken, PkceCodeChallenge, PkceCodeVerifier, RedirectUrl};
use std::{
    net::{IpAddr, Ipv4Addr, SocketAddr},
    sync::Arc,
};
use tokio::sync::broadcast;

mod auth;

fn main() {
    dotenv().expect(".env file not found");

    let (pkce_code_challenge, pkce_code_verifier) = PkceCodeChallenge::new_random_sha256();
    let socket_addr: SocketAddr = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(127, 0, 0, 1)), 9133);

    let socket_addr_localhost: String = socket_addr.to_string().replace("127.0.0.1", "localhost");
    let redirect_url: String = format!("http://{}/callback", socket_addr_localhost);

    let (token_sender, _) = broadcast::channel(10); // Create a broadcast channel

    let client = auth::create_client(RedirectUrl::new(redirect_url).unwrap());
    let state: auth::AuthState = auth::AuthState {
        csrf_token: CsrfToken::new_random(),
        pkce: Arc::new((
            pkce_code_challenge,
            PkceCodeVerifier::secret(&pkce_code_verifier).to_string(),
        )),
        client: Arc::new(client),
        socket_addr,
        token_sender,
    };

    tauri::Builder::default()
        .manage(state)
        .plugin(tauri_plugin_store::Builder::default().build())
        .invoke_handler(tauri::generate_handler![
            auth::authenticate
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
