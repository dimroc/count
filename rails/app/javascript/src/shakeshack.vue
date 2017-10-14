<template>
  <div id="app">
    <header>
      <h1>Shake Shack Line</h1>
      <h4>Madison Square Park, New York City</h4>
    </header>

    <div class="box">
      <header>
        <h4>Crowd Map</h4>
        <small>12:55pm EDT</small>
      </header>

      <crowdmap :frame="current" v-if="current" />

      <!--<section class="raw-feed">-->
        <!--<h4>Raw Feed</h4>-->
      <!--</section>-->

      <section class="chart">
        <h1>32</h1>
        <h4>People in line</h4>
      </section>
    </div>

    <footer>
      <h4>1,426 other snapshots over 14 days.</h4>
      <p>{{frames}}</p>
    </footer>
  </div>
</template>

<script>
import crowdmap from './crowdmap'

App.cable.subscriptions.create(
  { channel: "FramesChannel", room: "shakecam" },
  { received: function() { console.log(arguments); } });

export default {
  components: {
    crowdmap
  },
  data: function () {
    return {
      message: "Hello Dimitri!",
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
        this.frames = response.body;
        this.current = this.frames[0];
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
  border: 1px solid lighten($offwhite, 25%);
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
  font-size: 2.8rem;
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
