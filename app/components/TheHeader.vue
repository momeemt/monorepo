<template>
  <el-menu :router="true" mode="horizontal">
    <el-menu-item index="1" style="pointer-events:none;">
      CycleWords
    </el-menu-item>
    <el-menu-item :route="{ path: '/exams' }" index="2">
      テスト一覧
    </el-menu-item>
    <el-menu-item :route="{ path: '/words/new' }" index="3">
      単語を追加
    </el-menu-item>
    <el-menu-item :route="{ path: '/exams/new' }" index="4">
      テストをする
    </el-menu-item>
  </el-menu>
</template>

<script>
</script>

<style scoped>
</style>
