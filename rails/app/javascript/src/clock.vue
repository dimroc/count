<template>
  <small>{{time}}</small>
</template>

<script>
import moment from 'moment'
export default {
  data: function() {
    return {
      time: moment().format('LTS')
    }
  },
  mounted: function() {
    setInterval(() => {
      this.time = moment().format('LTS')
    }, 1000)
  }
}
</script>
