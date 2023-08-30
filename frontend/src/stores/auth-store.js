import { defineStore } from "pinia";

export const useAuthStore = defineStore({
  id: "auth",
  state: () => ({
    user: null,
    accessToken: null,
  }),
  actions: {
    setUser(user, accessToken) {
      this.user = user;
      this.accessToken = accessToken;
      this.router.push("/");
    },
    clearUser() {
      this.user = null;
      this.accessToken = null;
      this.router.push("/login");
    },
  },
});
