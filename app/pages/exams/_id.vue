<template>
  <el-card>
    <h1>{{ exam.name }}</h1>
    <el-table :data="results">
      <el-table-column prop="datetime" label="日付" />
      <el-table-column prop="point" label="得点" />
    </el-table>
    <h2>単語</h2>
    <el-table :data="words">
      <el-table-column prop="problem" label="日本語" />
      <el-table-column prop="answer" label="英語" />
    </el-table>
  </el-card>
</template>

<script>
import { mapGetters } from 'vuex'
export default {
  computed: {
    ...mapGetters('exams', ['exam']),
    ...mapGetters('words', ['words']),
    ...mapGetters('results', ['results'])
  },
  async asyncData ({ store, route }) {
    const id = await route.params.id
    await store.dispatch('exams/fetchExam', { id })
    await store.dispatch('results/fetchResultsFromExam', { examID: id })
    await store.dispatch('words/fetchWordsFromExam', { examID: id })
  }
}
</script>

<style scoped>

</style>
