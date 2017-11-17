<template>
  <section>
    <a v-if="today" :href="yesterdays_path">Yesterday</a>
    <small>{{time}}</small>
    <a v-if="!today" :href="todays_path">Now</a>
  </section>
</template>

<script>
import helper_mixin from './helper_mixin'
import moment from 'moment-timezone'
moment.tz.setDefault('America/New_York')
const MOMENT_FORMAT = 'ddd MMM D LTS z'

export default {
  mixins: [helper_mixin],
  data: function() {
    return {
      time: moment().format(MOMENT_FORMAT)
    }
  },
  computed: {
    yesterdays_path: function() {
      return `/date/${moment().add(-1, 'days').format(this.dateFormat)}`
    },
    todays_path: function() {
      return `/`
    },
    today: function() {
      return moment(this.date).format(this.dateFormat) == moment().format(this.dateFormat)
    }
  },
  mounted: function() {
    setInterval(() => {
      this.time = moment().format(MOMENT_FORMAT)
    }, 1000)
  }
}
</script>

<style scoped lang="scss">
section {
  float: right;
  margin-top: 5px;
}

small {
  background-color: rgb(83,83,83);
  color: white;
  border-radius: 15px;
  padding: 5px 10px;
  width: 190px;
  text-align: center;
  display: inline-block;
}
</style>
