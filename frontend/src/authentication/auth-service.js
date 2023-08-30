import { useAuthStore } from "src/stores/auth-store";
import * as msal from "@azure/msal-browser";
import { msalConfig } from "./auth-config";

const myMSALObj = new msal.PublicClientApplication(msalConfig);
const auth = useAuthStore();

function signIn() {
  const loginRequest = {
    scopes: ["openid", "profile", "User.Read"],
  };

  myMSALObj
    .loginPopup(loginRequest)
    .then((response) => {
      myMSALObj.setActiveAccount(response.account);

      const account = response.account;
      const accessToken = response.accessToken;

      if (account) {
        auth.setUser(account, accessToken);
      }
    })
    .catch((error) => {
      console.error(error);
    });
}

function getUser() {
  const account = myMSALObj.getActiveAccount();
  return account ? account : null;
}

async function signOut() {
  await myMSALObj.logoutPopup();
  auth.clearUser();
}

export { signIn, signOut, getUser };
