/* eslint no-console: 0 */
import Vue from 'vue'
import VueResource from 'vue-resource'
import Vue2Filters from 'vue2-filters'
import App from '../src/shakeshack.vue'
require('../src/vuefilters')

Vue.use(VueResource)
Vue.use(Vue2Filters)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue(App).$mount('#vue')
})
