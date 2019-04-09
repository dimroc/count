<template>
  <section>
    <a :href="day_before_path">Day Before</a>
    <small>{{time}}</small>
    <a v-if="!goldenDay" :href="goldenDays_path">Jun 7</a>
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
    goldenDays_path: function() {
      return `/`
    },
    goldenDay: function() {
      return moment(this.date).format(this.dateFormat) == this.goldenDate
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
