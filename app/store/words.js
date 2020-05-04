import moment from '~/plugins/moment'

export const state = () => ({
  words: []
})

export const getters = {
  words: state => state.words
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
  },
  deleteWord (state, { id }) {
    state.words = state.words.filter(w => w.id !== id)
  }
}

export const actions = {
  async fetchWord ({ commit }, { id }) {
    const word = await this.$axios.$get(`/words/${id}.json`)
    commit('addWord', { word: { ...word, id } })
  },
  async fetchWords ({ commit }) {
    const words = await this.$axios.$get(`/words.json`)
    commit('clearWords')
    if (words == null) { return }
    Object.entries(words)
      .reverse()
      .forEach(([id, content]) =>
        commit('addWord', {
          word: {
            id,
            ...content
          }
        })
      )
  },
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
  },
  async removeWord ({ commit }, { id }) {
    await this.$axios.$delete(`/words/${id}.json`)
    commit('deleteWord', { id })
  }
}
