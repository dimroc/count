/* eslint no-console: 0 */
import Vue from 'vue/dist/vue.esm'
import App from '../src/shakeshack.vue'

document.addEventListener('DOMContentLoaded', () => {
  const el = document.getElementById("app");
  const app = new Vue(App).$mount(el);
});
