<template>
  <section class="container words-page">
    <el-card style="flex: 1">
      <div slot="header" class="clearfix">
        <el-input v-model="formData.problem" placeholder="問題を入力" />
      </div>
      <div>
        <el-input v-model="formData.answer" placeholder="答えを入力" />
      </div>
      <div class="text-right" style="margin-top: 16px;">
        <el-button @click="registerWord" type="primary" round>
          <span class="el-icon-upload2" />
          <span>登録する</span>
        </el-button>
        <el-button @click="continueRegisterWord" type="primary" round>
          <span class="el-icon-upload2" />
          <span>連続して登録する</span>
        </el-button>
      </div>
    </el-card>
  </section>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
export default {
  computed: {
    ...mapGetters(['user'])
  },
  asyncData ({ redirect, store }) {
    if (!store.getters.user) {
      redirect('/')
    }
    return {
      formData: {
        problem: '',
        answer: ''
      }
    }
  },
  methods: {
    async register () {
      const payload = {
        user: this.user,
        ...this.formData
      }
      await this.publishWord({ payload })
    },
    async registerWord () {
      await this.register()
      await this.$router.push('/words')
      this.$notify({
        type: 'success',
        title: `単語登録完了`,
        message: `${this.formData.problem} / ${this.formData.answer} として登録しました`,
        position: 'bottom-right',
        duration: 3000
      })
    },
    async continueRegisterWord () {
      await this.register()
      this.$notify({
        type: 'success',
        title: `単語登録完了`,
        message: `${this.formData.problem} / ${this.formData.answer} として登録しました`,
        position: 'bottom-right',
        duration: 3000
      })
      this.formData = {}
    },
    ...mapActions('users', ['updateUser']),
    ...mapActions('words', ['publishWord'])
  }
}
</script>

<style scoped>
.words-page .el-table__row {
  cursor: pointer;
}
</style>
