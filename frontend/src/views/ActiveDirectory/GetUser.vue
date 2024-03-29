<template>
    <div v-if="!data">
        <div class="q-pa-md" style="max-width: 400px">

            <q-form @submit="onSubmit" class="q-gutter-md">
                <q-input filled v-model="name" label="ID or name" lazy-rules
                    :rules="[val => val && val.length > 0 || 'Please type something']" />

                <div>
                    <q-btn label="Submit" type="submit" color="primary" />
                </div>
            </q-form>
        </div>
    </div>
    <div v-else>
        <h1>{{ data.name }}</h1>
        <pre>{{ data }}</pre>

        <q-btn label="Json" color="primary" @click="showDialog" />

    </div>
</template>

<script>
import { useQuasar } from 'quasar'
import { ref, computed } from 'vue'

import { useEnvironmentStore } from "@/stores/environments";
import GeneralShowJsonDialog from "@/components/GeneralShowJsonDialog.vue";

export default {
    components: {
        GeneralShowJsonDialog
    },
    setup() {
        const $q = useQuasar()
        const environmentStore = useEnvironmentStore();
        const powershellApiAddress = computed(() => environmentStore.activeEnvironment?.powerShellApi);


        const name = ref(null)
        const data = ref(null)


        function onSubmit() {
            fetchData(name.value)
        }

        function fetchData() {
            const apiUrl = powershellApiAddress.value || 'fallback API URL if none is selected';
            const fullUrl = `${apiUrl}${name.value}`;

            fetch(fullUrl)
                .then(res => {
                    if (!res.ok) {
                        const error = new Error(res.statusText);
                        error.json = res.json();
                        throw error;
                    }
                    return res.json();
                })
                .then(json => {
                    data.value = json;
                })
                .catch(err => {
                    console.error('Error fetching data:', err);
                    $q.notify({
                        color: 'red-5',
                        textColor: 'white',
                        icon: 'warning',
                        message: err.message
                    });
                });
        }

        function showDialog() {
            $q.dialog({
                component: GeneralShowJsonDialog,
                componentProps: {
                    data: data.value,
                    title: name.value
                }
            })
        }

        return {
            name,
            data,

            onSubmit,
            fetchData,
            showDialog
        }
    }
}
</script>