<template>
  <q-layout view="lHh lpR lFf">
    <q-header elevated class="bg-grey-10">
      <q-toolbar>
        <q-toolbar-title>
          <q-item href="/">
            <q-item-section>
              <q-item-label>IAM Quick Menu</q-item-label>
            </q-item-section>
          </q-item>
        </q-toolbar-title>
      </q-toolbar>
    </q-header>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
export default {
  name: "LoginLayout",

  setup() {},
};
</script>
