import { auth } from '../plugins/firebase'

export default ({ route, store, redirect }) => {
  auth.onAuthStateChanged((user) => {
    if (!user && route.name !== '') { redirect('/') }
  })
}
