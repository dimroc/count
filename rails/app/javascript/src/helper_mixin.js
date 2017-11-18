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
      let frame = +this.$route.params.frame
      if (!frame && frame !== 0) {
        frame = this.frames[0].length - 1
      }
      return frame
    },
  }
}
