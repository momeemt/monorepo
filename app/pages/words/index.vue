<template>
  <section class="container words-page">
    <p>重いのでしばらく一覧はやめる</p>
    <!--    <el-card>-->
    <!--      <div slot="header" class="clearfix">-->
    <!--        <span>単語一覧</span>-->
    <!--      </div>-->
    <!--      <el-table-->
    <!--        :data="words"-->
    <!--        style="width: 100%"-->
    <!--        class="table"-->
    <!--      >-->
    <!--        <el-table-column prop="problem" label="日本語" />-->
    <!--        <el-table-column prop="answer" label="英語" />-->
    <!--        <el-table-column prop="examID" label="テストID" />-->
    <!--      </el-table>-->
    <!--    </el-card>-->
  </section>
</template>

<script>
import { mapGetters } from 'vuex'
export default {
  computed: {
    ...mapGetters('words', ['words'])
  },
  async asyncData ({ store }) {
    await store.dispatch('words/fetchWords')
  }
}
</script>

<style scoped>
.words-page .el-table__row {
  cursor: pointer;
}
</style>
