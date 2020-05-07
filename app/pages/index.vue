<template>
  <section class="index-page">
    <div>
      <el-button @click="signIn">
        ログインする
      </el-button>
    </div>
  </section>
</template>

<script>
import firebase from 'firebase'
export default {
  asyncData () {
    return {
      isAuth: false
    }
  },
  mounted () {
    firebase.auth().onAuthStateChanged((user) => {
      this.isAuth = !!user
      // if (this.isAuth) {
      //   this.$router.push('/home')
      // }
    })
  },
  methods: {
    signIn () {
      const provider = new firebase.auth.GoogleAuthProvider()
      firebase.auth().signInWithRedirect(provider)
    }
  }
}
</script>
