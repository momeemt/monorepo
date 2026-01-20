<template>
  <div>
    <p>Target</p>
    <BottomNavigation />
  </div>
</template>

<script lang="ts">
import BottomNavigation from '@/components/Organism/BottomNavigation'
import Vue from 'vue'

export default Vue.extend({
  name: 'Target',

  components: {
    BottomNavigation
  }
})
</script>

<style scoped>

</style>
