<template>
  <section>
    <a v-if="today" :href="day_before_path">Yesterday</a>
    <a v-if="!today" :href="day_before_path">Day Before</a>
    <small>{{time}}</small>
    <a v-if="!today" :href="todays_path">Now</a>
  </section>
</template>

<script>
import helper_mixin from './helper_mixin'
import moment from 'moment-timezone'
moment.tz.setDefault('America/New_York')
const MOMENT_FORMAT = 'MMM D LT'

export default {
  mixins: [helper_mixin],
  props: ['current'],
  computed: {
    time: function() {
      return moment(this.current.created_at).format(MOMENT_FORMAT)
    },
    day_before_path: function() {
      return `/dates/${moment(this.date).add(-1, 'days').format(this.dateFormat)}`
    },
    todays_path: function() {
      return `/`
    },
    today: function() {
      return moment(this.date).format(this.dateFormat) == moment().format(this.dateFormat)
    }
  }
}
</script>

<style scoped lang="scss">
section {
  float: right;
}
a {
  font-size: 12px;
}
small {
  background-color: #eff9fc;
  box-shadow: inset 0px 0 2px #e0e9eb;
  line-height: 15px;
  border-radius: 15px;
  padding: 5px 13px;
  text-align: center;
  display: inline-block;

}
</style>
