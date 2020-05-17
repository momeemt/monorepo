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
  },
  addProbabilityData (state, probability) {
    for (const word of state.words) {
      word.probability = probability[word.id]
    }
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
  async fetchWords ({ commit }) {
    commit('clearWords')
    const allShopShot = await firestore
      .collection('words')
      .get()
    if (allShopShot == null) { return }
    allShopShot.forEach((word) => {
      commit('addWords', word.data())
    })
  },
  addProbability ({ commit }, { probability }) {
    commit('addProbabilityData', probability)
  },
  async createWord ({ commit }, { payload }) {
    const collection = firestore.collection('words_v2').doc(payload.answer)
    const word = await collection.get()
    const exists = word.exists
    if (exists) {
      const wordData = word.data()
      const problem = payload.word.problem
      for (const value of problem) {
        wordData.problem.push(value)
      }
      await collection
        .set(wordData)
        .then(res => res)
        .catch(err => err)
    } else {
      await collection
        .set(payload.word)
        .then(res => res)
        .catch(err => err)
    }
  },
  async fetchWordsByExam ({ commit }, { payload }) {
    commit('clearWords')
    const words = payload.words
    const collection = firestore.collection('words_v2')
    for (const word of words) {
      try {
        const wordObj = await collection.doc(word).get()
        const answer = wordObj.id
        const wordData = wordObj.data()
        wordData.answer = answer
        commit('addWords', wordData)
      } catch (e) {
        console.log(word)
      }
    }
  },
  async applyScoring ({ commit }, { payload }) {
    const collection = firestore.collection('words_v2').doc(payload.answer)
    const word = await collection.get()
    const wordData = word.data()
    const scoring = payload.scoring
    wordData.scoring.push(scoring)
    await collection
      .set(wordData)
      .then(res => res)
      .catch(err => err)
  }
}
