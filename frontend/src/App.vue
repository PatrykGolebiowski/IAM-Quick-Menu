<template>
  <q-layout view="lHh Lpr lFf" class="bg-grey-9 text-white">
    <AppHeader />
    <AppDrawer />

    <q-page-container>
      <router-view />
    </q-page-container>

  </q-layout>
</template>

<script>
import AppHeader from '@/components/AppHeader.vue';
import AppDrawer from '@/components/AppDrawer.vue';

export default {
  name: 'MyLayout',
  components: {
    AppHeader,
    AppDrawer
  },
  setup() {

    return {

    }
  }
}
</script>

<style lang="sass">
.my-menu-link
  color: white
  background: #6E7BFB
</style>