<template>
  <q-drawer v-model="drawer" show-if-above :mini="miniState" @mouseover="miniState = false" @mouseout="miniState = true"
    :breakpoint="500" bordered :class="$q.dark.isActive ? 'bg-grey-9' : 'bg-grey-3'">

    <q-item clickable rel="noopener" :to="{ name: 'Dashboard' }" active-class="my-menu-link" exact>
      <q-item-section avatar>
        <q-icon name="dashboard" />
      </q-item-section>
      <q-item-section>
        <q-item-label>Dashboard</q-item-label>
      </q-item-section>
    </q-item>

    <q-list class="rounded-borders">
      <q-expansion-item dense-toggle expand-separator icon="folder_shared" label="Active directory"
        :content-inset-level="1">
        <q-item clickable :to="{ name: 'ADGetUser' }" active-class="my-menu-link">
          <q-item-section avatar>
            <q-icon name="school" />
          </q-item-section>
          <q-item-section>
            <q-item-label>Get object</q-item-label>
          </q-item-section>
        </q-item>
        <q-item clickable target="_blank" rel="noopener" href="https://quasar.dev">
          <q-item-section avatar>
            <q-icon name="school" />
          </q-item-section>
          <q-item-section>
            <q-item-label>Docs</q-item-label>
          </q-item-section>
        </q-item>
      </q-expansion-item>

      <q-expansion-item dense-toggle expand-separator icon="cloud_sync" label="Graph" :content-inset-level="1">
        <q-item clickable target="_blank" rel="noopener" href="https://quasar.dev">
          <q-item-section avatar>
            <q-icon name="school" />
          </q-item-section>
          <q-item-section>
            <q-item-label>Docs</q-item-label>
          </q-item-section>
        </q-item>
      </q-expansion-item>

      <q-expansion-item dense-toggle expand-separator icon="email" label="Exchange Online" :content-inset-level="1">
        <q-item clickable target="_blank" rel="noopener" href="https://quasar.dev">
          <q-item-section avatar>
            <q-icon name="school" />
          </q-item-section>
          <q-item-section>
            <q-item-label>Docs</q-item-label>
          </q-item-section>
        </q-item>
      </q-expansion-item>
    </q-list>

  </q-drawer>
</template>

<script>
import { ref } from 'vue'

export default {
  setup() {
    const drawer = ref(false)
    const miniState = ref(true)

    return {
      drawer,
      miniState,
    }
  }
}
</script>