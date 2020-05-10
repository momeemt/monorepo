import { firestore } from '~/plugins/firebase'
import moment from '~/plugins/moment'

export const state = () => ({
  results: [],
  result: {}
})

export const getters = {
  results: state => state.results,
  result: state => state.result
}

export const mutations = {
  addResult (state, result) {
    state.result = result
  },
  addResults (state, result) {
    state.results.push(result)
  },
  clearResults (state) {
    state.results = []
  }
}

export const actions = {
  async fetchResult ({ commit }, { id }) {
    await firestore
      .collection('results')
      .doc(id)
      .then((res) => {
        commit('addResult', res.data())
      })
  },
  async fetchResultsFromExam ({ commit }, { examID }) {
    commit('clearResults')
    const allSnapShot = await firestore
      .collection('results')
      .where('examID', '==', examID)
      .get()
    if (allSnapShot == null) { return }
    const results = []
    allSnapShot.forEach((result) => {
      const resultData = result.data()
      resultData.datetime = moment(resultData.datetime.toDate()).format('YYYY-MM-DD HH:mm:ss')
      results.push(resultData)
      commit('addResults', resultData)
    })
    return { results }
  },
  async fetchResults ({ commit }) {
    commit('clearResults')
    const allShopShot = await firestore
      .collection('results')
      .get()
    if (allShopShot == null) { return }
    allShopShot.forEach((result) => {
      commit('addResults', result.data())
    })
  }
}
