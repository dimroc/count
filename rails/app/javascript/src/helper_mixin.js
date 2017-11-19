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
      if (this.onLatestFrame) {
        return this.frames[0].length - 1
      } else {
        return +this.$route.params.frame
      }
    },
    onLatestFrame: function() {
      let frame = this.$route.params.frame
      return (frame == null || frame == undefined)
    }
  }
}
