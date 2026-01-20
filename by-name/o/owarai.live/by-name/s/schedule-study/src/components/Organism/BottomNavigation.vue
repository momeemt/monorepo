<template>
  <v-bottom-navigation
    fixed
    grow
  >
    <v-btn value="today" to="/">
      <span>Today</span>
      <v-icon>mdi-calendar-today</v-icon>
    </v-btn>
    <v-btn value="add" to="/addTask">
      <span>Add</span>
      <v-icon>mdi-plus</v-icon>
    </v-btn>
    <v-btn value="report" to="/Report">
      <span>Report</span>
      <v-icon>mdi-file-chart</v-icon>
    </v-btn>
    <v-btn value="target" to="Target">
      <span>Target</span>
      <v-icon>mdi-bullseye-arrow</v-icon>
    </v-btn>
  </v-bottom-navigation>
</template>

<script>
export default {
  name: 'BottomNavigation'
}
</script>

<style scoped>

</style>
