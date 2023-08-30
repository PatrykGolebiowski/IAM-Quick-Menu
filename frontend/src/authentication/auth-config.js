export const msalConfig = {
    auth: {
      clientId: "CLIENT_ID", 
      authority: "https://login.microsoftonline.com/TENANT_ID",
      redirectUri: "http://localhost:9300"
    },
    cache: {
      cacheLocation: "sessionStorage", // This configures where your cache will be stored
      storeAuthStateInCookie: false, // Set this to "true" if you are having issues on IE11 or Edge
    }
  };
  