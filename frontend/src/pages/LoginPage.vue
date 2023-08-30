<template>
  <q-page class="flex flex-center">
    <div class="fit column wrap justify-center items-center content-center">
      <img alt="Quasar logo" src="~assets/pigeobear.png" />
      <q-btn color="primary" label="Login with Azure AD" @click="signIn" />
    </div>
  </q-page>
</template>

<script>
import { defineComponent } from "vue";
import { signIn } from "src/authentication/auth-service.js";

export default defineComponent({
  name: "LoginPage",

  setup() {
    return {
      signIn,
    };
  },
});
</script>
