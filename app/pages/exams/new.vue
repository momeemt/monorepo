<template>
  <el-card>
    <template v-if="condition === 'startExam'">
      <p>テストをする</p>
      <el-select v-model="examName" @input="disabled = false" placeholder="テストを選ぶ">
        <el-option
          v-for="e in exams"
          :value="e.id"
          :key="e.id"
          :label="e.name"
        />
      </el-select>
      <el-button @click="startExam" :disabled="disabled">
        テスト開始
      </el-button>
    </template>
    <template v-else-if="condition === 'isTesting'">
      <p>問題</p>
      <div v-for="w in targetWords">
        <p>{{ w.problem }}</p>
        <el-input v-model="userAnswer[w.id]" />
      </div>
      <el-button @click="submitAnswer">
        解答
      </el-button>
    </template>
    <template v-else>
      <p>結果</p>
      <el-progress :percentage="examResult * 2" type="circle" />
      <p>{{ examResult }}点でした！</p>
      <p>間違えた単語を復習しておきましょう</p>
      <p>不正解だった単語</p>
      <el-table :data="wrongWords">
        <el-table-column prop="problem" label="日本語" />
        <el-table-column prop="answer" label="英語" />
      </el-table>
    </template>
  </el-card>
</template>

<script>
import { firestore } from '~/plugins/firebase'
export default {
  data () {
    return {
      examName: '',
      condition: 'startExam',
      disabled: true,
      targetWords: [],
      userAnswer: {},
      examResult: 0,
      wrongWords: []
    }
  },
  async asyncData () {
    const exams = []
    const examRef = firestore.collection('exams')
    const allExams = await examRef.get()
    allExams.forEach((e) => {
      exams.push(e.data())
    })
    const words = []
    const wordRef = firestore.collection('words')
    const allWords = await wordRef.get()
    allWords.forEach((w) => {
      words.push(w.data())
    })
    return { exams, words }
  },
  methods: {
    startExam () {
      this.condition = 'isTesting'
      this.words.forEach((w) => {
        if (w.examID === this.examName) {
          this.targetWords.push(w)
        }
      })
    },
    async addResult (point) {
      const dbResults = await firestore.collection('results')
      const datetime = new Date()
      const res = await dbResults
        .add({
          datetime,
          point
        })
        .then((res) => {
          return res.id
        })
        .catch((err) => {
          return err
        })
      return { res }
    },
    async submitAnswer () {
      let point = 0
      for (const word of this.targetWords) {
        const id = word.id
        const userAnswer = this.userAnswer[id]
        if (userAnswer === word.answer) {
          point++
        } else {
          this.wrongWords.push(word)
        }
      }
      this.examResult = point
      this.condition = 'result'
      const dbScoring = firestore.collection('scoring')
      const resultRes = await this.addResult(point)
      const resultID = resultRes.res
      for (const word of this.targetWords) {
        const id = word.id
        const userAnswer = this.userAnswer[id]
        if (userAnswer === word.answer) {
          dbScoring.add({
            resultID,
            wordID: id,
            judge: 1
          })
        } else {
          dbScoring.add({
            resultID,
            wordID: id,
            judge: 0
          })
        }
      }
    }
  }
}
</script>
