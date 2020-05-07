export const strict = false

export const state = () => ({
  user: null
})

export const getters = {
  user: state => state.user,
  isAuthenticated: state => !!state.user
}

export const mutations = {
  setUser (state, { user }) {
    state.user = { user }
  }
}

export const actions = {
  login ({ commit }, res) {
    const { user } = res
    commit('setUser', { user })
  }
}
