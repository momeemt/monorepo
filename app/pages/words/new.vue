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
    async registerWord () {
      const payload = {
        user: this.user,
        ...this.formData
      }
      await this.publishWord({ payload })
      await this.$router.push('/words')
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
