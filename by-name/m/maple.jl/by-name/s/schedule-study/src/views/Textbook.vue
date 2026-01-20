<template>
  <div>
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>教科書を追加する</v-card-title>
        <v-text-field
          v-model="textbook.name"
          label="教科書名"
          outlined
          dense
        ></v-text-field>
        <v-select
          v-model="textbook.subjects"
          :items="subjects"
          multiple
          outlined
          dense
          mandatory
        >
        </v-select>
        <v-text-field
          v-model="textbook.unit"
          label="単位"
          outlined
          dense
        ></v-text-field>
        <v-text-field
          v-model="textbook.allAmount"
          type="number"
          label="総分量"
          outlined
          dense
        ></v-text-field>
        <v-text-field
          v-model="textbook.progressAmount"
          label="今進んでいる分量"
          outlined
          dense
        ></v-text-field>
        <v-card-actions>
          <v-btn @click="saveTextbook" right text>保存</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-card>
      <v-card-title>教科書一覧</v-card-title>
      <v-list>
        <v-list-item v-for="(value, key) in getTextbooks" :key="key">
          <v-list-item-content>
            <v-list-item-title>{{ value.name }}</v-list-item-title>
            <v-list-item-subtitle>
              {{ value.progressAmount }}{{ value.unit }} / {{ value.allAmount }}{{ value.unit }} ({{ value.progressAmount / value.allAmount * 100 }}%)
            </v-list-item-subtitle>
          </v-list-item-content>
          <v-list-item-action v-for="(subject, key) in value.subjects" :key="key">
            <v-btn small ripple="false" elevation="0" color="indigo" class="white--text" rounded>
              {{ subject }}
            </v-btn>
          </v-list-item-action>
          <v-list-item-action>
            <v-btn icon>
              <v-icon
                @click="removeTextbook(value._id)"
                color="grey lighten-1"
              >mdi-delete</v-icon>
            </v-btn>
          </v-list-item-action>
        </v-list-item>
      </v-list>
      <v-card-actions>
        <v-btn text right @click="dialog = true">教科書を追加する</v-btn>
      </v-card-actions>
    </v-card>
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
import { mapGetters, mapActions } from 'vuex'

export default Vue.extend({
  name: 'Textbook',
  components: { BottomNavigation },
  data () {
    return {
      textbooks: [],
      textbook: {
        name: '',
        subjects: [],
        unit: 'ページ',
        allAmount: 0,
        progressAmount: 0
      },
      subjects: [
        '現代文',
        '古文',
        '漢文',
        '数学I',
        '数学A',
        '数学II',
        '数学B',
        '数学III',
        '物理',
        '物理基礎',
        '化学',
        '化学基礎',
        'コミュニケーション英語',
        '英語表現'
      ],
      dialog: false,
      snackbar: false
    }
  },
  computed: {
    ...mapGetters('Textbooks', [
      'getTextbooks'
    ])
  },
  methods: {
    saveTextbook () {
      this.addTextbook(this.textbook)
      this.textbook = {
        name: '',
        subjects: [],
        unit: 'ページ',
        allAmount: 0,
        progressAmount: 0
      }
      this.snackbar = true
      this.dialog = false
    },
    removeTextbook (id: string) {
      this.deleteTextbook(id)
    },
    ...mapActions('Textbooks', [
      'addTextbook',
      'deleteTextbook'
    ]),
    removeAll () {
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      const Database = require('nedb')
      const db = new Database({
        filename: 'textbooks.db'
      })
      db.loadDatabase()
      db.remove({}, { multi: true })
    }
  }
})
</script>

<style scoped>

</style>
