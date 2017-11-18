import moment from 'moment-timezone'

export default {
  computed: {
    date: function() {
      return this.$route.params.date || moment().format(this.dateFormat)
    },
    dateFormat: function() {
      return "YYYY-MM-DD"
    },
    currentFrameIndex: function() {
      return +this.$route.params.frame || 0
    },
  }
}
