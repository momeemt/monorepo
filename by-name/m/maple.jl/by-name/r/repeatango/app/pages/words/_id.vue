<template>
  <section class="container words-page">
    <div style="flex: 1;">
      <el-card v-if="word">
        <div slot="header" class="clearfix">
          <h2>{{ word.answer }}</h2>
          <small>by {{ word.user.id }}</small>
        </div>
        <p>{{ word.problem }}</p>
        <p class="text--right">
          {{ word.created_at | time }}
        </p>
      </el-card>
      <p>
        <nuxt-link to="/words">
          単語一覧に戻る
        </nuxt-link>
      </p>
    </div>
  </section>
</template>

<script>
// eslint-disable-next-line standard/object-curly-even-spacing
import { mapGetters /* , mapActions */ } from 'vuex'
import moment from '~/plugins/moment'
export default {
  filters: {
    time (val) {
      return moment(val).format('YYYY/MM/DD HH:mm:ss')
    }
  },
  computed: {
    word () {
      return this.words.find(w => w.id === this.$route.params.id)
    },
    ...mapGetters('words', ['words'])
  },
  async asyncData ({ store, route, error }) {
    const { id } = route.params
    if (!(store.getters['words/words'].find(w => w.id === id))) {
      return
    }
    try {
      await store.dispatch('words/fetchWord', { id })
      if (!(store.getters['words/words'].find(w => w.id === route.params.id))) {
        throw new Error('word not found')
      }
    } catch (e) {
      error({ statusCode: 404 })
    }
  }
}
</script>

<style scoped>
.words-page .el-table__row {
  cursor: pointer;
}
</style>
