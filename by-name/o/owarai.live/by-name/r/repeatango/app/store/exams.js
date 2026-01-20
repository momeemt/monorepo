import { firestore, timestamp } from '~/plugins/firebase'
import moment from '~/plugins/moment'

export const state = () => ({
  exams: [],
  exam: {}
})

export const getters = {
  exams: state => state.exams,
  exam: state => state.exam
}

export const mutations = {
  addExam (state, exam) {
    state.exam = exam
  },
  addExams (state, exam) {
    state.exams.push(exam)
  },
  clearExams (state) {
    state.exams = []
  }
}

export const actions = {
  async fetchExam ({ commit }, { id }) {
    const collection = firestore.collection('exams_v2').doc(id)
    const exam = await collection.get()
    const examData = exam.data()
    examData.startDate = moment(examData.startDate.toDate()).format('YYYY-MM-DD')
    commit('addExam', examData)
    return examData
  },
  async fetchExams ({ commit }) {
    const collection = firestore.collection('exams_v2').orderBy('id')
    const allSnapShot = await collection.get()
    commit('clearExams')
    if (allSnapShot == null) { return }
    allSnapShot.forEach((exam) => {
      const examData = exam.data()
      examData.startDate = moment(examData.startDate.toDate()).format('YYYY-MM-DD')
      commit('addExams', examData)
    })
  },
  async createExam ({ commit }, { payload }) {
    const collection = firestore.collection('exams_v2').doc(payload.id)
    await collection
      .set(payload)
      .then(res => res.doc)
      .catch(err => err)
  },
  async applyResult ({ commit }, { payload }) {
    const collection = firestore.collection('exams_v2').doc(payload.id)
    const exam = await collection.get()
    const examData = exam.data()
    const result = payload.result
    examData.results.push(result)
    await collection
      .set(examData)
      .then(res => res)
      .catch(err => err)
  },
  async fetchToDoExam ({ commit }) {
    commit('clearExams')
    const previousDays = [0, 1, 3, 7, 30, 60, 120]
    for (const beforeDate of previousDays) {
      const todo = await getTodoExam(beforeDate)
      todo.forEach((exam) => {
        const examData = exam.data()
        examData.startDate = moment(examData.startDate.toDate()).format('YYYY-MM-DD')
        examData.whenTask = beforeDate
        commit('addExams', examData)
      })
    }
  }
}

const getTodoExam = async (beforeDate) => {
  const todo = await firestore
    .collection('exams_v2')
    .where('startDate', '==', getYearDateObject(beforeDate))
    .get()
  return todo
}

const getYearDateObject = (beforeDate) => {
  const now = new Date()
  const today = new Date(
    now.getFullYear(),
    now.getMonth(),
    now.getDate() - beforeDate
  )
  return timestamp.fromDate(today)
}
