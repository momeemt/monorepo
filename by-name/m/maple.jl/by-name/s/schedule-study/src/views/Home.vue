<template>
  <v-app>
    <v-main>
      <v-container>
        <v-row>
          <v-col>
            <v-calendar-daily></v-calendar-daily>
          </v-col>
          <v-col>
            <v-row>
              <v-card>
                <v-card-title>今日の学習タスク</v-card-title>
                <v-card-text>
                  <v-list>
                    <v-list-item>出る順 準1級</v-list-item>
                  </v-list>
                </v-card-text>
              </v-card>
            </v-row>
            <v-row>
              <v-card>
                <v-card-title>進捗状況</v-card-title>
              </v-card>
            </v-row>
          </v-col>
        </v-row>
        <BottomNavigation />
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import BottomNavigation from '@/components/Organism/BottomNavigation'
import Vue from 'vue'

export default Vue.extend({
  name: 'Home',
  components: {
    BottomNavigation
  }
})
</script>
