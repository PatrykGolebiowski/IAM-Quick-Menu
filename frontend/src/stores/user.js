import { defineStore } from "pinia";


export const useUserStore = defineStore('user', {
  state: () => ({
    token: "",
    isLoggedIn: false
  }),
  getters: {
    getToken: (state) => state.token,
    getIsLoggedIn: (state) => state.isLoggedIn,
  },
  actions: {
    setToken(token) {
      this.token = token
      this.isLoggedIn = true
    },
  },
})