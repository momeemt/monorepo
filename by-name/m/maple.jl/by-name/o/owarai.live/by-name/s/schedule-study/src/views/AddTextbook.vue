<template>
  <div>
    <h1>教科書を追加する</h1>
    <v-text-field placeholder="教科書名" v-model="textbook.name"></v-text-field>
    <p>教科</p>
    <v-btn-toggle multiple v-model="textbook.subjects">
      <v-btn v-for="(value, key) in subjects" :key="key">
        {{ value }}
      </v-btn>
    </v-btn-toggle>
    <p>単位</p>
    <v-text-field placeholder="単位" v-model="textbook.unit"></v-text-field>
    <p>総分量</p>
    <v-text-field type="number" placeholder="総分量" v-model="textbook.allAmount"></v-text-field>
    <p>今進んでいる分量</p>
    <v-text-field type="number" placeholder="今進んでいる分量" v-model="textbook.progressAmount"></v-text-field>
    <v-btn @click="saveTextbook">保存</v-btn>
    <BottomNavigation />
    <v-snackbar
      v-model="snackbar"
    >
      教科書を追加しました
      <template v-slot:action="{ attrs }">
        <v-btn
          color="red"
          text
          v-bind="attrs"
          @click="snackbar = false"
        >
          閉じる
        </v-btn>
      </template>
    </v-snackbar>
  </div>
</template>

<script lang="ts">
import BottomNavigation from '@/components/Organism/BottomNavigation'
import Vue from 'vue'
// eslint-disable-next-line @typescript-eslint/no-var-requires
const Database = require('nedb')
const db = new Database({
  filename: 'textbooks.db'
})
db.loadDatabase()

export default Vue.extend({
  name: 'AddTextbook',
  data () {
    return {
      snackbar: false,
      textbook: {
        name: '',
        subjects: [],
        unit: 'ページ',
        allAmount: 0,
        progressAmount: 0
      },
      subjects: {
        Japanese: '現代文',
        classicalJapanese: '古文',
        classicalChinese: '漢文',
        math1: '数学I',
        mathA: '数学A',
        math2: '数学II',
        mathB: '数学B',
        math3: '数学III',
        advancedPhysics: '物理',
        basicPhysics: '物理基礎',
        advancedChemistry: '化学',
        basicChemistry: '化学基礎',
        EnglishCommunication: 'コミュニケーション英語',
        EnglishExpression: '英語表現'
      }
    }
  },
  components: {
    BottomNavigation
  },
  methods: {
    saveTextbook () {
      db.insert(this.textbook, (error: any, newTextbook: any) => {
        if (error !== null) {
          console.error(error)
        }
        console.log(newTextbook)
      })
      this.snackbar = true
    }
  }
})
</script>

<style scoped>

</style>
