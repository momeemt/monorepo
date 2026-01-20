import { firestore } from '~/plugins/firebase'

export const state = () => ({
  scoring: [],
  score: {},
  masteryRate: 0
})

export const getters = {
  scoring: state => state.scoring,
  score: state => state.score,
  masteryRate: state => state.masteryRate
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
  },
  setMasteryRate (state, rate) {
    state.masteryRate = rate
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
  async fetchScoringFromResults ({ commit }, { results }) {
    const resultArr = Array.from(results)
    commit('clearScoring')
    const sumPoint = {}
    const resultSize = resultArr.length
    for (let index = 0; index < resultSize; ++index) {
      const result = resultArr[index]
      const allSnapShot = await firestore
        .collection('scoring')
        .where('resultID', '==', result.id)
        .get()
      if (allSnapShot == null) { return }
      allSnapShot.forEach((score) => {
        const scoreData = score.data()
        if (sumPoint[scoreData.wordID]) {
          sumPoint[scoreData.wordID] += scoreData.judge
        } else {
          sumPoint[scoreData.wordID] = scoreData.judge
        }
        commit('addScoring', score.data())
      })
    }
    const probability = {}
    let masteryRate = 0
    Object.entries(sumPoint).forEach(([key, value]) => {
      masteryRate += value
      probability[key] = value / resultSize * 100
    })
    masteryRate = masteryRate / resultSize / 50 * 100
    masteryRate = Math.round(masteryRate * 10) / 10
    commit('setMasteryRate', masteryRate)
    return { probability }
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
