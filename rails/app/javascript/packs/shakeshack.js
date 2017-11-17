/* eslint no-console: 0 */
import Vue from 'vue'
import VueResource from 'vue-resource'
import App from '../src/shakeshack.vue'
require('../src/vuefilters')

Vue.use(VueResource)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue(App).$mount('#vue')
})
