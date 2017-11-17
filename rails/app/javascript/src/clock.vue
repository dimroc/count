<template>
  <section>
    <a :href="yesterdays_path">Yesterday</a>
    <small>{{time}}</small>
  </section>
</template>

<script>
import moment from 'moment-timezone'
moment.tz.setDefault('America/New_York')
const MOMENT_FORMAT = 'ddd MMM D LTS z'

export default {
  data: function() {
    return {
      time: moment().format(MOMENT_FORMAT)
    }
  },
  computed: {
    yesterdays_path: function() {
      return `/date/${moment().add(-1, 'days').format('YYYY-MM-DD')}`
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
