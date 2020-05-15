<template>
  <section class="container exams-page">
    <el-card>
      <div slot="header" class="clearfix">
        <span>テスト一覧</span>
      </div>
      <el-table
        :data="exams"
        @row-click="goExamShow"
        style="width: 100%"
        class="table"
      >
        <el-table-column prop="id" label="テスト名" />
        <el-table-column prop="words.length" label="問題数" />
      </el-table>
    </el-card>
  </section>
</template>

<script>
import { mapGetters } from 'vuex'
export default {
  computed: {
    ...mapGetters('exams', ['exams'])
  },
  async asyncData ({ store }) {
    await store.dispatch('exams/fetchExams')
  },
  methods: {
    goExamShow (exam) {
      this.$router.push(`/exams/${exam.id}`)
    }
  }
}
</script>

<style scoped>
  .words-page .el-table__row {
    cursor: pointer;
  }
</style>
