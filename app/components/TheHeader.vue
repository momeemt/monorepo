<template>
  <el-menu :router="true" mode="horizontal">
    <el-menu-item index="1" style="pointer-events:none;">
      CycleWords
    </el-menu-item>
    <el-menu-item :route="{ path: '/words' }" index="2">
      単語一覧
    </el-menu-item>
    <el-menu-item :route="{ path: '/exams' }" index="3">
      テスト
    </el-menu-item>
    <el-menu-item
      :route="{ path: `/users/${user.id}/` }"
      v-if="user"
      style="float: right;"
      index="4"
    >
      <span>{{ user.id }}</span>
    </el-menu-item>
    <el-menu-item :route="{ path: '/' }" v-else index="4" style="float: right;">
      <span>ログイン</span>
    </el-menu-item>
    <el-menu-item :route="{ path: '/words/new' }" index="5" style="float: right">
      単語を追加
    </el-menu-item>
    <el-menu-item :route="{ path: '/exams/new' }" index="6" style="float: right">
      テストをする
    </el-menu-item>
  </el-menu>
</template>

<script>
import { mapGetters } from 'vuex'
export default {
  computed: {
    ...mapGetters(['user'])
  }
}
</script>

<style scoped>

</style>
