<template>
  <section id="app">
    <div class="box" v-if="frames">
      <header>
        <clock />
        <div v-if="current.closed">
          <h1>No one in line because it's closed</h1>
        </div>

        <div v-else>
          <h1>{{current.line_count | round}} people in line</h1>
        </div>

        <h4>at
          <a href="https://www.shakeshack.com/location/madison-square-park" target="_blank">
            Shake Shack Madison Square Park, NYC
        </a>
      </h4>
      </header>

      <linechart :frames="frames" />
      <crowdmap :frame="current" />
    </div>
  </section>
</template>

<script>
import clock from './clock'
import crowdmap from './crowdmap'
import linechart from './linechart'

App.cable.subscriptions.create(
  { channel: "FramesChannel", room: "shakecam" },
  { received: function() { console.log(arguments); } });

export default {
  components: {
    clock,
    crowdmap,
    linechart
  },
  data: function () {
    return {
      message: "Hello Dimitri!",
      stats: null,
      frames: null,
      current: null
    }
  },
  created: function() {
    this.fetchFrames();
  },
  methods: {
    fetchFrames: function() {
      this.$http.get('/shakecams').then((response) => {
        this.frames = response.body.frames;
        this.stats = response.body.stats;
        this.current = this.frames[0][0];
      })
    }
  }
}
</script>

<style scoped lang="scss">
@import url('https://fonts.googleapis.com/css?family=Open+Sans');
$offwhite: #888;

#app {
  font-family: 'Open Sans', sans-serif;
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

.raw-feed {
}

.chart {
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
