<template>
  <q-header elevated class="bg-grey-6">
    <q-toolbar>

      <q-toolbar-title>
        <div text-bold>
          IAM Quick Menu -
          <text-subtitle1 :style="{ color: '#' + environmentStore.activeEnvironment?.color }">
            {{ environmentStore.activeEnvironment?.name }}
          </text-subtitle1>
        </div>

      </q-toolbar-title>


      <q-btn round flat>
        <!-- Avatar -->
        <q-avatar size="26px">
          <img src="https://cdn.quasar.dev/img/boy-avatar.png">
        </q-avatar>
        <q-tooltip>Account</q-tooltip>
        <!-- Avatar -->
        <q-menu>
          <q-list style="min-width: 100px">
            <!-- Settings -->
            <q-item clickable v-close-popup to="/settings">
              <q-item-section>Settings</q-item-section>
            </q-item>
            <!-- Settings -->
            <q-separator />
            <!-- Environments -->
            <q-item clickable>
              <q-item-section>Environments</q-item-section>
              <q-item-section side>
                <q-icon name="keyboard_arrow_right" />
              </q-item-section>
              <!-- Environment names -->
              <q-menu anchor="top end" self="top start">
                <q-list>
                  <q-item v-for="env in environmentStore.environments" :key="env.name" dense clickable
                    @click="setActiveEnvironment(env.name)">
                    <q-item-section>{{ env.name }}</q-item-section>
                  </q-item>
                </q-list>
              </q-menu>
              <!-- Environment names -->
            </q-item>
            <!-- Environments -->
          </q-list>
        </q-menu>
      </q-btn>
    </q-toolbar>
  </q-header>
</template>


<script>
import { useEnvironmentStore } from '@/stores/environments';

export default {
  name: 'MyLayout',
  setup() {
    const environmentStore = useEnvironmentStore();

    function setActiveEnvironment(name) {
      environmentStore.setActiveEnvironment(name);
    }

    return {
      environmentStore,
      setActiveEnvironment,
    }
  }
}
</script>