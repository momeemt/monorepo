<template>
  <el-card>
    <h1>{{ exam.id }}</h1>
    <el-divider />
    <p>習得率</p>
    <el-progress :percentage="0" type="circle" />
    <el-table :data="results">
      <el-table-column prop="id" label="日付" />
      <el-table-column prop="point" label="得点" />
    </el-table>
    <h2>単語</h2>
    <el-table id="momeemtWordTable" :data="words" :row-class-name="tableRowClassName">
      <el-table-column prop="problem[0].word" label="日本語" />
      <el-table-column prop="answer" label="英語" />
      <el-table-column prop="probability" label="得点" />
    </el-table>
  </el-card>
</template>

<script>
import { mapGetters } from 'vuex'
export default {
  // TODO: 日本語のpropに意味が複数ある場合に文字列を結合させるcomputedをかく
  computed: {
    ...mapGetters('exams', ['exam']),
    ...mapGetters('words', ['words']),
    ...mapGetters('results', ['results'])
  },
  async asyncData ({ store, route }) {
    const id = await route.params.id
    const exam = await store.dispatch('exams/fetchExam', { id })
    await store.dispatch('results/fetchResultsFromExam', { payload: exam.results })
    // await store.dispatch('scoring/fetchScoringFromResults', { results })
    await store.dispatch('words/fetchWordsByExam', { payload: exam })
    // await store.dispatch('words/addProbability', { probability })
    // return { probability }
  },
  methods: {
    tableRowClassName ({ row, _ }) {
      const prob = row.probability
      if (prob >= 90) {
        return 'master'
      } else if (prob >= 50) {
        return 'trying'
      } else {
        return 'doNotKnow'
      }
    }
  }
}
</script>

<style lang="scss">
  #momeemtWordTable {
    .trying {
      background: #fef263;
    }
    .doNotKnow {
      background: #f2a0a1;
    }
    tr {
      pointer-events: none;
    }
  }
</style>
