export const state = () => ({
  users: []
})

export const getters = {
  users: state => state.users
}

export const mutations = {
  addUser (state, { user }) {
    state.users.push(user)
  },
  addUserWord (state, { user, word }) {
    state.userWords[user.id].push(word)
  },
  clearUserWords (state, { user }) {
    state.userWords[user.id] = []
  }
}

export const actions = {
  async fetchUser ({ commit }, { id }) {
    const user = await this.$axios.$get(`/users/${id}.json`)
    commit('addUser', { user })
  }
}
