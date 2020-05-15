import { firestore } from '~/plugins/firebase'

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
    commit('addExam', exam.data())
  },
  async fetchExams ({ commit }) {
    const collection = firestore.collection('exams_v2').orderBy('id')
    const allSnapShot = await collection.get()
    commit('clearExams')
    if (allSnapShot == null) { return }
    allSnapShot.forEach((exam) => {
      commit('addExams', exam.data())
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
  }
}
