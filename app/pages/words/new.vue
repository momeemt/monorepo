<template>
  <section class="container words-page">
    <el-card style="flex: 1">
      <el-input-number v-model="numOfWords" />
      <el-date-picker v-model="startDate" />
      <el-form>
        <el-input v-model="examName" placeholder="テスト名を入力" />
        <div v-for="i in numOfWords">
          <p>{{ i }}問目</p>
          <el-form-item>
            <el-input v-model="formData[`problem${i}`]" placeholder="問題を入力" />
          </el-form-item>
          <el-form-item>
            <el-select v-model="formData[`class${i}`]" placeholder="品詞">
              <el-option
                v-for="item in options"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-input v-model="formData[`answer${i}`]" placeholder="答えを入力" />
          </el-form-item>
        </div>
      </el-form>
      <el-button @click="numOfWords += 1">
        問題数を増やす
      </el-button>
      <div class="text-right" style="margin-top: 16px;">
        <el-button @click="register" type="primary" round>
          <span class="el-icon-upload2" />
          <span>登録する</span>
        </el-button>
      </div>
    </el-card>
  </section>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import { Loading } from 'element-ui'
export default {
  data () {
    return {
      numOfWords: 10,
      options: [
        {
          value: 'noon',
          label: '名詞'
        },
        {
          value: 'verb',
          label: '動詞'
        },
        {
          value: 'adjective',
          label: '形容詞'
        },
        {
          value: 'adverb',
          label: '副詞'
        },
        {
          value: 'conjunction',
          label: '接続詞'
        },
        {
          value: 'preposition',
          label: '前置詞'
        },
        {
          value: 'idioms',
          label: '熟語'
        }
      ]
    }
  },
  computed: {
    ...mapGetters(['user'])
  },
  asyncData () {
    return {
      formData: {},
      examName: '',
      startDate: ''
    }
  },
  methods: {
    async register () {
      const examPayload = {
        id: this.examName,
        words: [],
        results: [],
        startDate: this.startDate
      }
      let loadingProgress = 0
      const loadingInstance = Loading.service({ text: '0' })
      for (let i = 1; i <= this.numOfWords; ++i) {
        const problem = this.formData[`problem${i}`]
        const answer = this.formData[`answer${i}`]
        const word = {
          problem: [],
          scoring: []
        }
        const problemArr = problem.split(',')
        for (const pr of problemArr) {
          const prData = {
            word: pr,
            class: this.formData[`class${i}`]
          }
          word.problem.push(prData)
        }
        const payload = {
          word,
          answer
        }
        await this.createWord({ payload })
        examPayload.words.push(answer)
        loadingProgress += 100 / this.numOfWords
        loadingInstance.text = String(loadingProgress) + '%'
      }
      this.createExam({ payload: examPayload })
      loadingInstance.close()
      await this.$router.push('/exams')
      this.$notify({
        type: 'success',
        title: `単語登録完了`,
        message: `登録しました`,
        position: 'bottom-right',
        duration: 3000
      })
    },
    ...mapActions('exams', ['createExam']),
    ...mapActions('words', ['createWord'])
  }
}
</script>

<style scoped>
.words-page .el-table__row {
  cursor: pointer;
}
</style>
