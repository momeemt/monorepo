<template>
  <section class="container users-page">
    <h2>{{ user.id }}</h2>
    <div>{{ user.id }}さんの単語</div>
    <el-table
      :data="userWords"
    >
      <el-table-column
        prop="problem"
        label="日本語"
      />
      <el-table-column
        prop="answer"
        label="英語"
      />
      <el-table-column
        prop="created_at"
        label="投稿日時"
      />
    </el-table>
  </section>
</template>

<script>
import { mapGetters } from 'vuex'
import moment from '~/plugins/moment'
export default {
  computed: {
    user () {
      const user = this.users.find(u => u.id === this.$route.params.id)
      if (!user) { return null }
      return Object.assign({ words: [] }, user)
    },
    userWords () {
      return Object.entries(this.user.words).map(([id, word]) => {
        word.created_at = moment(word.created_at).format('YYYY/MM/DD HH:mm:ss')
        return { id, ...word }
      })
    },
    ...mapGetters('users', ['users'])
  },
  async asyncData ({ store, route, error }) {
    const { id } = route.params
    try {
      await store.dispatch('users/fetchUser', { id })
    } catch (e) {
      error({ statusCode: 404 })
    }
  }
}
</script>

<style scoped>

</style>
