<template>
  <el-menu :router="true" mode="horizontal">
    <el-menu-item index="1" style="pointer-events:none;">
      repeatango
    </el-menu-item>
    <el-menu-item :route="{ path: '/words' }" index="2">
      単語一覧
    </el-menu-item>
    <no-ssr>
      <el-menu-item :route="{ path: '/' }" index="4" style="float: right;">
        <span>ログイン</span>
      </el-menu-item>
    </no-ssr>
    <el-menu-item :route="{ path: '/words/new' }" index="5" style="float: right">
      単語を追加
    </el-menu-item>
  </el-menu>
</template>

<script>
export default {
  name: 'TheHeader'
}
</script>

<style scoped>

</style>
