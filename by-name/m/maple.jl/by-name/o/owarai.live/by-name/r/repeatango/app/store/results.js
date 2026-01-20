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
  fetchResultsFromExam ({ commit }, { payload }) {
    commit('clearResults')
    for (const result of payload) {
      result.id = moment(result.id.toDate()).format('YYYY-MM-DD HH:mm:ss')
      commit('addResults', result)
    }
    return { results: payload }
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
