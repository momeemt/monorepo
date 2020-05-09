import { firestore } from '~/plugins/firebase'

export const state = () => ({
  words: [],
  word: {}
})

export const getters = {
  words: state => state.words,
  word: state => state.word
}

export const mutations = {
  addWord (state, word) {
    state.word = word
  },
  addWords (state, word) {
    state.words.push(word)
  },
  clearWords (state) {
    state.words = []
  }
}

export const actions = {
  async fetchWord ({ commit }, { id }) {
    await firestore
      .collection('words')
      .doc(id)
      .then((res) => {
        commit('addWord', res.data())
      })
  },
  async fetchWordsFromExam ({ commit }, { examID }) {
    commit('clearWords')
    const allSnapShot = await firestore
      .collection('words')
      .where('examID', '==', examID)
      .get()
    if (allSnapShot == null) { return }
    allSnapShot.forEach((word) => {
      commit('addWords', word.data())
    })
  },
  async fetchWords ({ commit }) {
    commit('clearWords')
    const allShopShot = await firestore
      .collection('words')
      .get()
    if (allShopShot == null) { return }
    allShopShot.forEach((word) => {
      commit('addWords', word.data())
    })
  }
}
