<script>
App.cable.subscriptions.create(
  { channel: "FramesChannel", room: "shakecam" },
  { received: function() { console.log(arguments); } });

export default {
  data: function () {
    return {
      message: "Hello Dimitri!"
    }
  }
}
</script>

<style scoped  lang="scss">
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
