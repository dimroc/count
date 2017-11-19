<template>
  <section id="shakecam">
    <div class="box" v-if="frames">
      <header>
        <clock :current="current"/>
        <h1>{{lineMessage}}</h1>
        <h4>at
          <a href="https://www.shakeshack.com/location/madison-square-park" target="_blank">
            Shake Shack Madison Square Park, NYC
        </a>
      </h4>
      </header>

      <linechart :frames="frames" :current="current" />
      <crowdmap :current="current" />
    </div>
  </section>
</template>

<script>
import clock from './clock'
import crowdmap from './crowdmap'
import linechart from './linechart'
import helper_mixin from './helper_mixin'

export default {
  mixins: [helper_mixin],
  components: {
    clock,
    crowdmap,
    linechart
  },
  data: function() {
    return {
      stats: null,
      frames: null,
      current: null
    }
  },
  computed: {
    lineMessage: function() {
      let lc = Math.round(this.current.line_count || 0)
      if(this.current.closed) {
        return "No one in line (closed)"
      } else if(lc == 0) {
        return "No one in line"
      } else if(lc == 1) {
        return `${Math.round(this.current.line_count)} person in line`
      } else {
        return `${Math.round(this.current.line_count)} people in line`
      }
    }
  },
  created: function() {
    this.fetchFrames()
  },
  watch: {
    '$route' (to, from) {
      this.current = this.frames[0][this.currentFrameIndex];
    }
  },
  methods: {
    fetchFrames: function() {
      this.$http.get('/shakecams', { params: { date: this.date }}).then((response) => {
        this.frames = response.body.frames;
        this.stats = response.body.stats;
        this.current = this.frames[0][this.currentFrameIndex];
        this.connectToCable()
      })
    },
    connectToCable: function() {
      let that = this
      App.cable.subscriptions.create(
        { channel: "FramesChannel", room: `shakecam-${this.date}` },
        { received: function(frame) {
          that.frames[0].push(frame)
          if (that.onLatestFrame) { that.current = frame }
        }});
    }
  }
}
</script>

<style scoped lang="scss">
$offwhite: #888;

section {
  font-family: 'arquette';
  font-smooth: always;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  margin: auto;
  max-width: 750px;

  > header {
    margin: 50px 0;
  }
}

.box {
  background-color: white;
  //border: 1px solid lighten($offwhite, 25%);
  box-shadow: 0px 0 5px #aaa;
  padding: 20px;
  margin-bottom: 20px;

  > header {
    height: 40px;
    clear: both;

    small { float: right; }
    h4 { float: left; }
  }
}

h1 {
  font-size: 2.0rem;
}

h4 {
  font-size: 1.05rem;
  color: $offwhite;
}

small {
  font-size: 0.8rem;
  color: $offwhite;
}
</style>
