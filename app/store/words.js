import moment from '~/plugins/moment'

export const state = () => ({
  words: []
})

export const getters = {
  posts: state => state.words
}

export const mutations = {
  addWord (state, { word }) {
    state.words.push(word)
  },
  updateWord (state, { word }) {
    state.words = state.words.map(w => (w.id === word.id ? word : w))
  },
  clearWords (state) {
    state.words = []
  }
}

export const actions = {
  async publishWord ({ commit }, { payload }) {
    const user = await this.$axios.$get(`/users/${payload.user.id}.json`)
    const wordID = (await this.$axios.$post('/words.json', payload)).name
    const createdAt = moment().format()
    const word = { id: wordID, ...payload, created_at: createdAt }
    const putData = { id: wordID, ...payload, created_at: createdAt }
    delete putData.user
    await this.$axios.$put(`/users/${user.id}/words.json`, [
      ...(user.words || []),
      putData
    ])
    commit('addWord', { word })
  }
}
