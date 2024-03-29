<template>
  <q-card>
    <q-tabs v-model="tab" dense class="text-grey" active-color="primary" indicator-color="primary" align="justify"
      narrow-indicator>
      <q-tab name="environment" label="Environment" />
      <q-tab name="api" label="API" />
      <q-tab name="essentialLinks" label="Essential links - TO DO" />
    </q-tabs>

    <q-separator />

    <q-tab-panels v-model="tab" animated>
      <q-tab-panel name="environment">

        <q-form class="q-gutter-md">
          <q-input filled v-model="environmentDetails.name" label="Name" lazy-rules
            :rules="[val => val && val.length > 0 || 'Please type something']" />
          <q-input filled v-model="environmentDetails.color" label="Color" lazy-rules
            :rules="[val => val && val.length > 0 || 'Please type something']" />
        </q-form>

      </q-tab-panel>

      <q-tab-panel name="api">

        <q-form class="q-gutter-md">
          <q-input filled v-model="environmentDetails.powerShellApi" label="Powershell API address" lazy-rules
            :rules="[val => val && val.length > 0 || 'Please type something']" />

          <q-input filled v-model="environmentDetails.ldapApi" label="LDAP API address" lazy-rules
            :rules="[val => val && val.length > 0 || 'Please type something']" />
        </q-form>
      </q-tab-panel>

      <q-tab-panel name="essentialLinks">
        <div class="text-h6">Essential links</div>
        Lorem ipsum dolor sit amet consectetur adipisicing elit.
      </q-tab-panel>

    </q-tab-panels>

  </q-card>
  <q-btn flat label="Delete" color="negative" @click="deleteEnvironment" />
  <q-btn label="Save" type="submit" color="primary" @click="saveSettings" />
</template>


<script>
import { computed, onMounted, ref, watch } from 'vue'
import { useQuasar } from 'quasar'
import { useEnvironmentStore } from "@/stores/environments";


export default {
  setup() {
    const $q = useQuasar();
    const environmentStore = useEnvironmentStore();

    const tab = ref('environment');
    let environmentDetails = ref({
      name: environmentStore.activeEnvironment?.name || '',
      color: environmentStore.activeEnvironment?.color || '',
      powerShellApi: environmentStore.activeEnvironment?.powerShellApi || '',
      ldapApi: environmentStore.activeEnvironment?.ldapApi || '',
    });


    const validateForm = () => {
      const hasNull = Object.values(environmentDetails.value).some(value => value === null || value === '');
      return !hasNull;
    }

    const saveSettings = async () => {
      if (!validateForm()) {
        $q.notify({ type: 'negative', message: 'Please fill all the fields.' });
        return;
      }
      const result = await environmentStore.updateEnvironment(environmentStore.activeEnvironment.name, environmentDetails.value);
      if (result) {
        $q.notify({ type: 'positive', message: 'Settings saved successfully.' });
      } else {
        $q.notify({ type: 'negative', message: 'Failed to save settings.' });
      }
    };

    const deleteEnvironment = () => {
      $q.dialog({
        title: 'Confirm',
        message: `Are you sure you want to delete the environment "${environmentStore.activeEnvironment.name}"?`,
        cancel: true,
        persistent: true
      }).onOk(async () => {
        try {
          const result = await environmentStore.deleteEnvironment(environmentStore.activeEnvironment.name);
          if (result) {
            $q.notify({ type: 'positive', message: 'Environment deleted successfully.' });
          } else {
            $q.notify({ type: 'negative', message: 'Failed to delete the environment.' });
          }
        } catch (error) {
          $q.notify({ type: 'negative', message: 'An error occurred while deleting the environment.' });
        }
      })
    };

    watch(() => environmentStore.activeEnvironment, (newVal) => {
      if (newVal) {
        environmentDetails.value = {
          name: newVal.name || '',
          color: newVal.color || '',
          powerShellApi: newVal.powerShellApi || '',
          ldapApi: newVal.ldapApi || '',
        };
      }
    }, { deep: true });



    return {
      tab,
      environmentDetails,
      saveSettings,
      deleteEnvironment,
    }
  }
}
</script>