<template>
  <small>{{time}}</small>
</template>

<script>
import moment from 'moment-timezone'
moment.tz.setDefault('America/New_York')

export default {
  data: function() {
    return {
      time: moment().format('LTS z')
    }
  },
  mounted: function() {
    setInterval(() => {
      this.time = moment().format('LTS z')
    }, 1000)
  }
}
</script>
