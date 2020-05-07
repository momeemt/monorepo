import firebase from 'firebase/app'
import 'firebase/auth'
import 'firebase/firestore'

const firebaseConfig = {
  apiKey: 'AIzaSyCKTlgdd_SXqdQ9WcUaFP0NRJzySHujN70',
  authDomain: 'cycle-words.firebaseapp.com',
  databaseURL: 'https://cycle-words.firebaseio.com',
  projectId: 'cycle-words',
  storageBucket: 'cycle-words.appspot.com',
  messagingSenderId: '199106701273',
  appId: '1:199106701273:web:232fb90690e69204971bc8',
  measurementId: 'G-CEC6XY5S5Q'
}

if (!firebase.apps.length) {
  firebase.initializeApp(firebaseConfig)
}

export const auth = firebase.auth()
export const firestore = firebase.firestore()
