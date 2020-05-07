<template>
  <section class="container exams-page">
    <el-card>
      <div slot="header" class="clearfix">
        <span>テスト一覧</span>
      </div>
      <el-table
        :data="exams"
        style="width: 100%"
        class="table"
      >
        <el-table-column prop="name" label="テスト名" />
      </el-table>
    </el-card>
  </section>
</template>

<script>
import { firestore } from '~/plugins/firebase'

export default {
  async asyncData () {
    const exams = []
    const colRef = firestore.collection('exams')
    const allSnapShot = await colRef.get()
    allSnapShot.forEach((w) => {
      exams.push(w.data())
    })
    return { exams }
  }
}
</script>

<style scoped>
  .words-page .el-table__row {
    cursor: pointer;
  }
</style>
