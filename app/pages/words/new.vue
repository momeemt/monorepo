<template>
  <section class="container words-page">
    <el-card style="flex: 1">
      <el-form>
        <el-input v-model="examName" placeholder="テスト名を入力" />
        <div v-for="i in 50">
          <p>{{ i }}問目</p>
          <el-form-item>
            <el-input v-model="formData[`problem${i}`]" placeholder="問題を入力" />
          </el-form-item>
          <el-form-item>
            <el-input v-model="formData[`answer${i}`]" placeholder="答えを入力" />
          </el-form-item>
        </div>
      </el-form>
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
import { firestore } from '~/plugins/firebase'
export default {
  computed: {
    ...mapGetters(['user'])
  },
  asyncData () {
    return {
      formData: {},
      examName: ''
    }
  },
  methods: {
    async addExam () {
      const dbExams = await firestore.collection('exams')
      const res = await dbExams
        .add({
          name: this.examName
        })
        .then((res) => {
          return res.id
        })
        .catch((err) => {
          return err
        })
      return { res }
    },
    async register () {
      const res = await this.addExam()
      const examID = res.res
      const dbWords = firestore.collection('words')
      for (let i = 1; i <= 50; ++i) {
        const problem = this.formData[`problem${i}`]
        const answer = this.formData[`answer${i}`]
        await dbWords.add({
          id: `${examID}${i}`,
          problem,
          answer,
          examID
        })
      }
    },
    async registerWord () {
      await this.register()
      await this.$router.push('/words')
      this.$notify({
        type: 'success',
        title: `単語登録完了`,
        message: `登録しました`,
        position: 'bottom-right',
        duration: 3000
      })
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
