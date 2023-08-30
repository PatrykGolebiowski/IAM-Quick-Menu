<template>
  <div class="q-pa-md" style="max-width: 600px">
    <div v-if="showGraphData">
      <q-card>
        <q-card-section>
          <div class="text-h6">"Me" information</div>
        </q-card-section>
        <q-separator />

        <q-card-section>
          <div v-for="(value, key) in graphData" :key="key">
            <q-input
              outlined
              :model-value="value"
              :label="key"
              stack-label
              readonly
            />
          </div>
        </q-card-section>
      </q-card>
    </div>
  </div>
</template>

<script>
import { defineComponent, ref, onMounted, onBeforeMount } from "vue";
import { useQuasar } from "quasar";
import { useAuthStore } from "src/stores/auth-store";
import { getGraphMe } from "src/services/graph_api";

export default defineComponent({
  name: "GraphMe",

  setup() {
    const $q = useQuasar();

    const auth = useAuthStore();
    const token = auth.accessToken;

    const graphData = ref(null);
    const showGraphData = ref(false);

    function onSubmit() {
      $q.loading.show();

      getGraphMe(token)
        .then((data) => {
          graphData.value = data;
          showGraphData.value = true;
        })
        .catch((error) => {
          if (error.message === "Network Error") {
            $q.notify({
              type: "negative",
              message: "Network Error: Unable to reach the server.",
            });
          } else {
            console.error("Error:", error);
            $q.notify({
              type: "negative",
              message: "An error occurred. Please try again later.",
            });
          }
        })
        .finally(() => {
          $q.loading.hide();
        });
    }

    onBeforeMount(() => {
      $q.loading.show();
    });

    onMounted(onSubmit);

    return {
      graphData,
      showGraphData,
      onSubmit,
    };
  },
});
</script>
