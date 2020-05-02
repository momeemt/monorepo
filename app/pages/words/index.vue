<template>
  <section class="container words-page">
    <el-card>
      <div slot="header" class="clearfix">
        <span>新規投稿</span>
      </div>
      <el-table
        :data="showWords"
        style="width: 100%"
        class="table"
      >
        <el-table-column prop="hint" label="日本語" />
        <el-table-column prop="answer" label="英語" />
        <el-table-column prop="user.user_id" label="投稿者" width="180" />
        <el-table-column prop="created_at" label="投稿日時" width="240" />
      </el-table>
    </el-card>
  </section>
</template>

<script>
export default {
  computed: {
    showWords () {
      return [
        {
          id: '1',
          hint: '発表',
          answer: 'presentation',
          created_at: '2020/01/01 12:00:00',
          user: {
            user_id: 'pasta'
          }
        },
        {
          id: '2',
          hint: '製品',
          answer: 'product',
          created_at: '2020/01/02 12:00:00',
          user: {
            user_id: 'pasta'
          }
        }
      ]
    }
  }
}
</script>

<style scoped>
.words-page .el-table__row {
  cursor: pointer;
}
</style>
