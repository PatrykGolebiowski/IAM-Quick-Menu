<template>
    <div class="q-pa-md fixed-center" style="max-width: 400px">
        <div class="row justify-center">
            <div class="col">
                <img :src="imageSrc">
            </div>
        </div>
        <div class="row">
            <div class="col">
                <form class="row justify-center" @submit.prevent="login">
                    <button type="submit">Sign in with Azure AD</button>
                </form>

                <p>{{ token }}</p>
            </div>
        </div>
    </div>

</template>

<script>
import { ref } from "vue";
import { invoke } from "@tauri-apps/api/tauri";
import { useUserStore } from "@/stores/user";
import { useRouter, useRoute } from 'vue-router';
import imageSrc from '@/assets/logo.png';

export default {
    name: "Login",
    setup() {
        const router = useRouter();
        const store = useUserStore();
        const token = ref("");

        async function login() {
            // Learn more about Tauri commands at https://tauri.app/v1/guides/features/command
            //token.value = await invoke("authenticate");
            token.value = "WHATEVER";
            store.setToken(token.value);
            router.push({ name: "Dashboard" });
        }

        return {
            imageSrc,
            token,

            login
        }
    }
}
</script>

<style scoped>
.login {
    max-width: 300px;
    margin: 0 auto;
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.form-group {
    margin-bottom: 10px;
}

label {
    display: block;
}

input[type="email"],
input[type="password"] {
    width: 100%;
    padding: 5px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

button {
    display: block;
    margin-top: 10px;
    padding: 5px 10px;
    background-color: #007bff;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

button:hover {
    background-color: #0056b3;
}
</style>
