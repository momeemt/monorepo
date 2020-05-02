<template>
  <section class="container">
    <el-card style="flex: 1">
      <div slot="header" class="clearfix">
        <span>ログイン</span>
      </div>
      <form>
        <div class="form-content">
          <span>ユーザー</span>
          <el-input v-model="formData.id" placeholder="" />
        </div>
        <div class="form-content">
          <el-checkbox v-model="isCreateMode">
            アカウントを作成する
          </el-checkbox>
        </div>
        <div class="text-right">
          <el-button type="primary">
            {{ buttonText }}
          </el-button>
        </div>
      </form>
    </el-card>
  </section>
</template>

<script>
export default {
  computed: {
    buttonText () {
      return this.isCreateMode ? '新規登録' : 'ログイン'
    }
  },
  asyncData () {
    return {
      isCreateMode: false,
      formData: {
        id: ''
      }
    }
  }
}
</script>

<style>
  .form-content {
    margin: 16px 0;
  }
</style>
