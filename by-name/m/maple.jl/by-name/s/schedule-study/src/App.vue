<template>
  <v-app id="app">
    <router-view />
  </v-app>
</template>

<script lang="ts">
import Vue from 'vue'

export default Vue.extend({
  name: 'App',

  components: {},

  data: () => ({
    date: {}
  }),

  methods: {}
})
</script>
