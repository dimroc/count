/* eslint no-console: 0 */
import Vue from 'vue/dist/vue.esm.js'
import Vue2Filters from 'vue2-filters'
import VueResource from 'vue-resource'
import VueRouter from 'vue-router'
import App from '../src/shakeshack.vue'

Vue.use(VueResource)
Vue.use(Vue2Filters)
Vue.use(VueRouter)

const router = new VueRouter({
  mode: 'history',
  routes: [
    { path: '/dates/:date', component: App, children: [
      { path: 'frames/:frame', component: App },
    ]},
    { path: '/', component: App }
  ]
})

document.addEventListener('DOMContentLoaded', () => {
  const mountee = new Vue({
    router,
    template: `<router-view></router-view>`
  }).$mount('#shakecam')
})
