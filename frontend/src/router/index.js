import { createRouter, createWebHistory } from "vue-router";

import Dashboard from "@/views/Dashboard.vue";
import ADGetUser from "@/views/ActiveDirectory/GetUser.vue";
import Login from "@/views/Auth/Login.vue";
import Settings from "@/views/Settings/Settings.vue";

const routes = [
  { path: "/", name: "Dashboard", component: Dashboard },
  { path: "/settings", name: "Settings", component: Settings },
  { path: "/activedirectory/getuser", name: "ADGetUser", component: ADGetUser },
  { path: "/auth/login", name: "Login", component: Login },
  { path: "/auth/login", name: "Login", component: Login },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
