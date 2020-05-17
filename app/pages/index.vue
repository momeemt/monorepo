<template>
  <section class="index-page">
    <el-card>
      <div>
        <p>今日の暗記タスク</p>
        <el-divider />
      </div>
      <el-table
        :data="exams"
        @row-click="goExamShow"
        style="width: 100%"
        class="table"
      >
        <el-table-column prop="id" label="テスト名" />
        <el-table-column prop="whenTask" label="タスク" />
        <el-table-column prop="words.length" label="問題数" />
        <el-table-column prop="startDate" label="開始日" />
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
    await store.dispatch('exams/fetchToDoExam')
  },
  methods: {
    goExamShow (exam) {
      this.$router.push(`/exams/${exam.id}`)
    }
  }
}
</script>
