import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

// eslint-disable-next-line @typescript-eslint/no-var-requires
const Database = require('nedb')
const db = new Database({
  filename: 'textbooks.db'
})
db.loadDatabase()

interface RootState {
  version: string;
}

interface RootGettersInterface {
  version: string;
}

interface State {
  textbooks: object;
}

interface Textbook {
  name: string;
  subjects: Array<string>;
  unit: string;
  allAmount: number;
  progressAmount: number;
  _id: string;
}

type Getters<S, G> = {
  [K in keyof G]: (state: S, getters: G) => G[K];
}

interface GettersInterface {
  getTextbooks: object;
}

type Mutations<S, M> = {
  [K in keyof M]: (state: S, payload: M[K]) => void;
}

interface MutationsInterface {
  add: Textbook;
  delete: string;
}

type Actions<S, A, G = {}, M = {}, RS = {}, RG = {}> = {
  [K in keyof A]: (ctx: Context<S, A, G, M, RS, RG>, payload: A[K]) => any;
}

interface ActionsInterface {
  addTextbook: Textbook;
  deleteTextbook: string;
}

type Context<S, A, G, M, RS, RG> = {
  commit: Commit<M>;
  dispatch: Dispatch<A>;
  state: S;
  getters: G;
  rootState: RS;
  rootGetters: RG;
}

type Commit<M> = <T extends keyof M>(type: T, payload?: M[T]) => void;
type Dispatch<A> = <T extends keyof A>(type: T, payload?: A[T]) => any;

const state: State = {
  textbooks: {}
}

db.find({}, (_: Error | null, docs: Array<Textbook>) => {
  const textbooksObject: any = {}
  for (const doc of docs) {
    textbooksObject[doc._id] = doc
  }
  state.textbooks = textbooksObject
})

const getters: Getters<State, GettersInterface> = {
  getTextbooks (state) {
    return state.textbooks
  }
}

const mutations: Mutations<State, MutationsInterface> = {
  add (state, payload) {
    Vue.set(state.textbooks, payload._id, payload)
  },
  delete (state, payload) {
    Vue.delete(state.textbooks, payload)
  }
}

const actions: Actions<
  State,
  ActionsInterface,
  GettersInterface,
  MutationsInterface,
  RootState,
  RootGettersInterface
> = {
  addTextbook (ctx, payload) {
    db.insert(payload, (error: any, newTextbook: any) => {
      if (error !== null) {
        console.error(error)
      }
      ctx.commit('add', newTextbook)
    })
  },
  deleteTextbook (ctx, payload) {
    console.log(payload)
    db.remove({ _id: payload })
    ctx.commit('delete', payload)
  }
}

const textbooks = {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
}

export const Textbooks = textbooks
