<template>
  <div>
    <p>AddTask</p>
    <BottomNavigation />
  </div>
</template>

<script lang="ts">
import BottomNavigation from '@/components/Organism/BottomNavigation'
import Vue from 'vue'

export default Vue.extend({
  name: 'AddTask',

  components: {
    BottomNavigation
  }
})
</script>

<style scoped>

</style>
