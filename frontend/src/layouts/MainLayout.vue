<template>
  <q-layout view="lHh lpR lFf">
    <q-header elevated class="bg-grey-10">
      <q-toolbar>
        <q-btn
          flat
          dense
          round
          @click="leftDrawerOpen = !leftDrawerOpen"
          aria-label="Menu"
          icon="menu"
        />

        <q-toolbar-title>
          <q-item href="/">
            <q-item-section>
              <q-item-label>IAM Quick Menu</q-item-label>
            </q-item-section>
          </q-item>
        </q-toolbar-title>

        <div class="q-gutter-sm row items-center no-wrap">
          {{ user.username }}
        </div>
      </q-toolbar>
    </q-header>

    <q-drawer
      v-model="leftDrawerOpen"
      show-if-above
      elevated
      class="q-pa-md bg-grey-10 text-white"
    >
      <q-list>
        <q-expansion-item
          v-for="item in essentialLinksMenu"
          :key="item.label"
          :header-inset-level="0"
          expand-separator
          :label="item.label"
          :icon="item.icon"
          dark
        >
          <q-item
            v-for="child in item.children"
            :key="child.label"
            clickable
            tag="a"
            :blank="child.blank"
            :href="child.href"
            target="blank"
            dark
          >
            <q-item-section avatar> </q-item-section>
            <q-item-section>
              <q-item-label>{{ child.label }}</q-item-label>
            </q-item-section>
          </q-item>
        </q-expansion-item>

        <q-expansion-item
          v-for="item in drawerMenu"
          :key="item.label"
          :header-inset-level="0"
          expand-separator
          :label="item.label"
          :icon="item.icon"
          dark
        >
          <q-item
            v-for="child in item.children"
            :key="child.label"
            clickable
            tag="a"
            :to="child.href"
            dark
          >
            <q-item-section avatar> </q-item-section>
            <q-item-section>
              <q-item-label>{{ child.label }}</q-item-label>
            </q-item-section>
          </q-item>
        </q-expansion-item>
      </q-list>
    </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
import { ref } from "vue";
import { getUser } from "src/authentication/auth-service.js";

export default {
  name: "LayoutDefault",

  setup() {
    const user = ref(getUser());

    const essentialLinksMenu = ref([
      {
        label: "Essential Links",
        icon: "grade",
        children: [
          {
            label: "Reddit",
            href: "https://www.reddit.com/",
          },
          {
            label: "9GAG",
            href: "https://9gag.com/",
          }
        ],
      },
    ]);

    const drawerMenu = ref([
      {
        label: "Azure",
        icon: "terminal",
        children: [
          {
            label: "Get me",
            href: "/graph/user/me",
          },
          {
            label: "Get licenses",
            href: "/graph/users/licenseDetails",
          },
          {
            label: "Revoke sign in session",
            href: "/graph/users/revokeSignInSession",
          },
        ],
      },
    ]);

    return {
      leftDrawerOpen: ref(false),
      essentialLinksMenu,
      drawerMenu,
      user,
    };
  },
};
</script>
