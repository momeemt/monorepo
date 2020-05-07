<template>
  <section class="container words-page">
    <el-card>
      <div slot="header" class="clearfix">
        <span>単語一覧</span>
      </div>
      <el-table
        :data="words"
        style="width: 100%"
        class="table"
      >
        <el-table-column prop="problem" label="日本語" />
        <el-table-column prop="answer" label="英語" />
        <el-table-column prop="examID" label="テストID" />
      </el-table>
    </el-card>
  </section>
</template>

<script>
import { firestore } from '~/plugins/firebase'

export default {
  async asyncData () {
    const words = []
    const colRef = firestore.collection('words')
    const allSnapShot = await colRef.get()
    allSnapShot.forEach((w) => {
      words.push(w.data())
    })
    return { words }
  }
}
</script>

<style scoped>
.words-page .el-table__row {
  cursor: pointer;
}
</style>
