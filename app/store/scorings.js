import { firestore } from '~/plugins/firebase'

export const state = () => ({
  scoring: [],
  score: {}
})

export const getters = {
  scoring: state => state.scoring,
  score: state => state.score
}

export const mutations = {
  addScore (state, score) {
    state.score = score
  },
  addScoring (state, scoring) {
    state.scoring.push(scoring)
  },
  clearScoring (state) {
    state.scoring = []
  }
}

export const actions = {
  async fetchScore ({ commit }, { id }) {
    await firestore
      .collection('scoring')
      .doc(id)
      .then((res) => {
        commit('addScore', res.data())
      })
  },
  async fetchScoringFromResult ({ commit }, { resultID }) {
    commit('clearScoring')
    const allSnapShot = await firestore
      .collection('results')
      .where('resultID', '==', resultID)
      .get()
    if (allSnapShot == null) { return }
    allSnapShot.forEach((score) => {
      commit('addResults', score.data())
    })
  },
  async fetchScoring ({ commit }) {
    commit('clearScoring')
    const allShopShot = await firestore
      .collection('scoring')
      .get()
    if (allShopShot == null) { return }
    allShopShot.forEach((score) => {
      commit('addScoring', score.data())
    })
  }
}
