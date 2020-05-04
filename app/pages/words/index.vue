<template>
  <section class="container words-page">
    <el-card>
      <div slot="header" class="clearfix">
        <span>単語一覧</span>
      </div>
      <el-table
        :data="showWords"
        @row-click="handleClick"
        style="width: 100%"
        class="table"
      >
        <el-table-column prop="problem" label="日本語" />
        <el-table-column prop="answer" label="英語" />
        <el-table-column prop="user.id" label="投稿者" width="180" />
        <el-table-column prop="created_at" label="投稿日時" width="240" />
        <el-table-column
          label="Operations"
          width="120"
        >
          <template slot-scope="scope">
            <el-button
              @click.native.stop="deleteRow(scope.$index, showWords)"
              type="text"
              size="small">
              削除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </section>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import moment from '~/plugins/moment'
export default {
  computed: {
    showWords () {
      return this.words.map((word) => {
        word.created_at = moment(word.created_at).format('YYYY/MM/DD HH:mm:ss')
        return word
      })
    },
    ...mapGetters('words', ['words'])
  },
  async asyncData ({ store }) {
    await store.dispatch('words/fetchWords')
  },
  methods: {
    handleClick (word) {
      this.$router.push(`/words/${word.id}`)
    },
    async deleteRow (index, words) {
      await this.removeWord(words[index])
    },
    ...mapActions('words', ['removeWord'])
  }
}
</script>

<style scoped>
.words-page .el-table__row {
  cursor: pointer;
}
</style>
