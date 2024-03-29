import { createApp } from "vue";
import { Quasar, Notify, Dialog } from "quasar";
import { createPinia } from "pinia";
import router from "./router";
import App from "./App.vue";

import { useUserStore } from "./stores/user";
import { useEnvironmentStore } from "./stores/environments";
// import { useEnvironmentStore } from "./stores/environments";

// Quasar styles
import "@quasar/extras/material-icons/material-icons.css";
import "quasar/src/css/index.sass";

const app = createApp(App);
const pinia = createPinia();

/// Load stores
const userStore = useUserStore(pinia);
const environmentStore = useEnvironmentStore(pinia);
environmentStore.init();

app.use(Quasar, {
  plugins: { Notify, Dialog },
  config: { dark: true, notify: { position: "top-right" } },
});

app.use(router);
app.use(pinia);
app.config.devtools = true;

router.beforeEach(async (to, from) => {
  var isLoggedIn = userStore.getIsLoggedIn;

  if (!isLoggedIn && to.name !== "Login") {
    return { name: "Login" };
  }
});

app.mount("#app");
