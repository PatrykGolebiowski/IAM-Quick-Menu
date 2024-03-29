<template>
  <div>
    <q-btn-group push>
      <q-btn v-for="env in environmentStore.environments" :key="env.name" :label="env.name"
        :icon="env.name === environmentStore.activeEnvironment.name ? 'check' : 'timeline'"
        @click="selectEnvironment(env.name)" />
      <q-btn icon="add" @click="addEnvironment" />
    </q-btn-group>
  </div>

</template>


<script>
import { useEnvironmentStore } from '@/stores/environments';
import { useQuasar } from 'quasar'
import { ref } from "vue";

export default {
  setup() {
    const $q = useQuasar();
    const manageEnvironment = ref(false);
    const environmentStore = useEnvironmentStore();

    function selectEnvironment(name) {
      environmentStore.setActiveEnvironment(name);
    }

    async function addEnvironment() {
      $q.dialog({
        title: 'Add new environment',
        message: 'Enter the name for the new environment (Minimum 3 characters):',
        prompt: {
          model: '',
          isValid: val => val.length > 2,
          type: 'text'
        },
        cancel: true,
        persistent: true
      }).onOk(async name => {
        await environmentStore.createEnvironment({
          name: name
        });
      });
    }

    return {
      environmentStore,
      manageEnvironment,
      addEnvironment,
      selectEnvironment,
    }
  }
}
</script>
