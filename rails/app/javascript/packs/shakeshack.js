/* eslint no-console: 0 */
import Vue from 'vue'
import VueResource from 'vue-resource'
import App from '../src/shakeshack.vue'

Vue.use(VueResource)

document.addEventListener('DOMContentLoaded', () => {
  document.body.appendChild(document.createElement('spa'))
  const app = new Vue(App).$mount('spa')
})
