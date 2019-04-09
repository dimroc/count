import moment from 'moment-timezone'

export default {
  computed: {
    goldenDate: function() {
      return "2018-06-07"
    },
    date: function() {
      // originally defaulted to now, instead choose golden date of
      // 2018-06-07/frames/126
      // return this.$route.params.date || moment().format(this.dateFormat)
      return this.$route.params.date || "2018-06-07"
    },
    dateFormat: function() {
      return "YYYY-MM-DD"
    },
    currentFrameIndex: function() {
      if (this.onLatestFrame) {
        //return this.frames[0].length - 1
        return 126
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
