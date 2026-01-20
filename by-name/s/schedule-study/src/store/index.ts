import Vue from 'vue'
import Vuex from 'vuex'

import { Textbooks } from './Textbook'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    Textbooks
  }
})
