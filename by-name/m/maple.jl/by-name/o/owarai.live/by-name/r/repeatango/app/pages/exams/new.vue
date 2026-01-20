<template>
  <el-card>
    <template v-if="condition === 'startExam'">
      <p>テストをする</p>
      <el-select v-model="examName" @input="disabled = false" placeholder="テストを選ぶ">
        <el-option
          v-for="exam in exams"
          :value="exam.id"
          :key="exam.id"
          :label="exam.name"
        />
      </el-select>
      <el-button @click="startExam" :disabled="disabled">
        テスト開始
      </el-button>
    </template>
    <template v-else-if="condition === 'isTesting'">
      <div v-for="w in words">
        <p>一文字目: {{ w.answer[0] }}</p>
        <ul v-for="p in w.problem">
          <li>{{ p.word }}</li>
        </ul>
        <el-input v-model="userAnswer[w.answer]" />
      </div>
      <el-button @click="submitAnswer">
        解答
      </el-button>
    </template>
    <template v-else>
      <p>結果</p>
      <el-progress :percentage="resultPoint * 100 / numOfProblems" type="circle" />
      <p>{{ resultPoint }}点でした！</p>
      <p>間違えた単語を復習しておきましょう</p>
      <p>不正解だった単語</p>
      <el-table :data="wrongWords">
        <el-table-column prop="problem[0].word" label="日本語" />
        <el-table-column prop="answer" label="英語" />
      </el-table>
    </template>
  </el-card>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
export default {
  data () {
    return {
      examName: '',
      condition: 'startExam',
      disabled: true,
      targetWords: [],
      userAnswer: {},
      resultPoint: 0,
      numOfProblems: 0,
      wrongWords: []
    }
  },
  computed: {
    ...mapGetters('exams', ['exams', 'exam']),
    ...mapGetters('words', ['words'])
  },
  async asyncData ({ store }) {
    await store.dispatch('exams/fetchExams')
  },
  methods: {
    startExam () {
      this.fetchExam({ id: this.examName })
      this.fetchWordsByExam({ payload: this.exam })
      console.log(this.exam)
      this.numOfProblems = 50 // TODO:lengthでエラー、なぜ this.exam.words.length
      this.condition = 'isTesting'
    },
    async submitAnswer () {
      let point = 0
      const resultID = new Date()
      for (const word of this.words) {
        const answer = word.answer
        const userAnswer = this.userAnswer[answer]
        if (userAnswer === word.answer) {
          point++
          const payload = {
            answer,
            scoring: {
              resultID,
              judge: 1
            }
          }
          await this.applyScoring({ payload })
        } else {
          this.wrongWords.push(word)
          const payload = {
            answer,
            scoring: {
              resultID,
              judge: 0
            }
          }
          await this.applyScoring({ payload })
        }
      }
      const payload = {
        id: this.exam.id,
        result: {
          point,
          id: resultID
        }
      }
      this.resultPoint = point
      this.condition = 'result'
      await this.applyResult({ payload })
    },
    ...mapActions('exams', ['fetchExam', 'applyResult']),
    ...mapActions('words', ['fetchWordsByExam', 'applyScoring'])
  }
}
</script>
