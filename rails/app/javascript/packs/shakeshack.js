/* eslint no-console: 0 */
import Vue from 'vue/dist/vue.esm.js'
import Vue2Filters from 'vue2-filters'
import VueResource from 'vue-resource'
import VueRouter from 'vue-router'
import ShakeShack from '../src/shakeshack.vue'

Vue.use(VueResource)
Vue.use(Vue2Filters)
Vue.use(VueRouter)

const router = new VueRouter({
  mode: 'history',
  routes: [
    { path: '/dates/:date', component: ShakeShack, children: [
      { path: 'frames/:frame', component: ShakeShack },
    ]},
    { path: '/', component: ShakeShack }
  ]
})

document.addEventListener('DOMContentLoaded', () => {
  const mountee = new Vue({
    router,
    template: `<router-view></router-view>`
  }).$mount('#shakecam')
})
