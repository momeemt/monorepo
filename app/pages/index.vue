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
          <el-button @click="handleClickSubmit" type="primary">
            {{ buttonText }}
          </el-button>
        </div>
      </form>
    </el-card>
  </section>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import Cookies from 'universal-cookie'
export default {
  computed: {
    buttonText () {
      return this.isCreateMode ? '新規登録' : 'ログイン'
    },
    ...mapGetters(['user'])
  },
  asyncData ({ redirect, store }) {
    if (store.getters.user) {
      redirect('/words')
    }
    return {
      isCreateMode: false,
      formData: {
        id: ''
      }
    }
  },
  methods: {
    async handleClickSubmit () {
      const cookies = new Cookies()
      if (this.isCreateMode) {
        try {
          await this.register({ ...this.formData })
          this.$notify({
            type: 'success',
            title: 'アカウント作成完了',
            message: `${this.formData.id} として登録しました`,
            position: 'bottom-right',
            duration: 5000
          })
          cookies.set('user', JSON.stringify(this.user))
          await this.$router.push('/words')
        } catch (_) {
          this.$notify.error({
            title: 'アカウント作成失敗',
            message: '既に登録されているか、不正なユーザーIDです',
            position: 'bottom-right',
            duration: 5000
          })
        }
      } else {
        try {
          await this.login({ ...this.formData })
          this.$notify({
            type: 'success',
            title: 'ログイン成功',
            message: `${this.formData.id}としてログインしました`,
            position: 'button-right',
            duration: 5000
          })
          cookies.set('user', JSON.stringify(this.user))
          await this.$router.push('/words/')
        } catch (e) {
          this.$notify.error({
            title: 'ログイン失敗',
            message: '不正なユーザーIDです',
            position: 'bottom-right',
            duration: 5000
          })
        }
      }
    },
    ...mapActions(['login', 'register'])
  }
}
</script>

<style>
  .form-content {
    margin: 16px 0;
  }
</style>
