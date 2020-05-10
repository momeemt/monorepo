<template>
  <el-card>
    <h1>{{ exam.name }}</h1>
    <el-divider />
    <p>習得率</p>
    <el-progress type="circle" :percentage="masteryRate"/>
    <el-table :data="results">
      <el-table-column prop="datetime" label="日付" />
      <el-table-column prop="point" label="得点" />
    </el-table>
    <h2>単語</h2>
    <el-table :data="words" :row-class-name="tableRowClassName" id="momeemtWordTable">
      <el-table-column prop="problem" label="日本語" />
      <el-table-column prop="answer" label="英語" />
      <el-table-column prop="probability" label="得点" />
    </el-table>
  </el-card>
</template>

<script>
import { mapGetters } from 'vuex'
export default {
  computed: {
    ...mapGetters('exams', ['exam']),
    ...mapGetters('words', ['words']),
    ...mapGetters('results', ['results']),
    ...mapGetters('scoring', ['masteryRate'])
  },
  async asyncData ({ store, route }) {
    const id = await route.params.id
    await store.dispatch('exams/fetchExam', { id })
    const { results } = await store.dispatch('results/fetchResultsFromExam', { examID: id })
    const { probability } = await store.dispatch('scoring/fetchScoringFromResults', { results })
    await store.dispatch('words/fetchWordsFromExam', { examID: id })
    await store.dispatch('words/addProbability', { probability })
    return { probability }
  },
  methods: {
    tableRowClassName ({ row, rowIndex }) {
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
