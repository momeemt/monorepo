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
    await firestore
      .collection('exams')
      .doc(id)
      .get()
      .then((res) => {
        commit('addExam', res.data())
      })
  },
  async fetchExams ({ commit }) {
    const collection = firestore.collection('exams')
    const allSnapShot = await collection.get()
    commit('clearExams')
    if (allSnapShot == null) { return }
    allSnapShot.forEach((exam) => {
      commit('addExams', exam.data())
    })
  }
}
