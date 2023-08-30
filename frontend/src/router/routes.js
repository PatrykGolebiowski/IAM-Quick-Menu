const routes = [
  {
    path: "/login",
    component: () => import("layouts/LoginLayout.vue"),
    children: [
      {
        path: "",
        name: "Login",
        component: () => import("pages/LoginPage.vue"),
      },
    ],
  },
  {
    path: "/",
    component: () => import("layouts/MainLayout.vue"),
    children: [{ path: "", component: () => import("pages/IndexPage.vue") }],
  },
  {
    path: "/graph",
    component: () => import("layouts/MainLayout.vue"),
    children: [
      {
        path: "user",
        children: [
          {
            path: "me",
            component: () => import("pages/Graph/Me.vue"),
          },
        ],
      },
      {
        path: "users",
        children: [
          {
            path: "licenseDetails",
            component: () => import("pages/Graph/GetUsersLicenseDetails.vue"),
          },
          {
            path: "revokeSignInSession",
            component: () => import("pages/Graph/RevokeSignInSession.vue"),
          },
        ],
      },
    ],
  },
  // Always leave this as last one,
  // but you can also remove it
  {
    path: "/:catchAll(.*)*",
    component: () => import("pages/ErrorNotFound.vue"),
  },
];

export default routes;
