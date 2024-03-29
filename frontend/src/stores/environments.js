import { defineStore } from "pinia";
import { ref, computed, watch } from "vue";
import { Store } from "tauri-plugin-store-api";

const settingsStore = new Store(".environments.dat");
const DEFAULT_ENVIRONMENT = {
  name: "",
  color: "FFFFFF",
  powerShellApi: "https://example.com/powershell/api/",
  ldapApi: "https://example.com/ldap/api/",
};

export const useEnvironmentStore = defineStore("environments", () => {
  // States
  const environments = ref([]);
  const activeEnvironment = ref(null);

  // Actions
  async function loadEnvironments() {
    environments.value = (await settingsStore.get("environments")) || [];
  }

  async function init() {
    await loadEnvironments();
    if (!environments.value || environments.value.length === 0) {
      await createEnvironment({ name: "Default" });
    }
    if (environments.value.length > 0) {
      activeEnvironment.value = environments.value[0];
    }
  }

  function setActiveEnvironment(environmentName) {
    const matchedEnvironment = environments.value.find(
      (environment) => environment.name === environmentName
    );
    activeEnvironment.value = matchedEnvironment || null;
  }

  async function createEnvironment(environmentDetails) {
    try {
      const newEnvironment = { ...DEFAULT_ENVIRONMENT, ...environmentDetails };
      environments.value.push(newEnvironment);

      await settingsStore.set("environments", environments.value);
      await settingsStore.save();

      setActiveEnvironment(newEnvironment.name);

      return true;
    } catch (error) {
      console.error("Failed to create environment:", error);
      return false;
    }
  }

  async function updateEnvironment(environmentName, environmentDetails) {
    const matchedEnvironment = environments.value.find(
      (environment) => environment.name === environmentName
    );

    if (!matchedEnvironment) {
      console.error(
        `Failed to update environment: Environment ${environmentDetails.name} not found`
      );
      return false;
    } else {
      // Update matchedEnvironment with environmentDetails
      Object.assign(matchedEnvironment, environmentDetails);

      await settingsStore.set("environments", environments.value);
      await settingsStore.save();

      return true;
    }
  }

  async function deleteEnvironment(environmentName) {
    if (environments.value.length === 1) {
      console.error(
        "Failed to delete environment, at least one environment must be active"
      );
      return false;
    }
    try {
      // Filter out the environment to delete
      environments.value = environments.value.filter(
        (environment) => environment.name !== environmentName
      );

      // Set another environment as active or set to null
      activeEnvironment.value =
        environments.value.length > 0 ? environments.value[0] : null;

      // Persist the updated list of environments
      await settingsStore.set("environments", environments.value);
      await settingsStore.save();

      return true;
    } catch (error) {
      console.error("Failed to delete environment:", error);
      return false;
    }
  }

  return {
    // States
    environments,
    activeEnvironment,
    // Actions
    loadEnvironments,
    init,
    setActiveEnvironment,
    createEnvironment,
    updateEnvironment,
    deleteEnvironment,
  };
});
