<template>
  <section class="chart">
    <svg width="500" height="300"></svg>
    <h1>32</h1>
    <h4>People in line</h4>
  </section>
</template>

<script>
import Vue from 'vue'
const d3 = require('d3');

export default {
  props: ['frames'],
  mounted: function() {
    this.drawLine()
  },
  watch: {
    frames: function(newValue) {
      this.drawLine()
    }
  },
  methods: {
    drawLine: function() {
      let svg = d3.select(this.$el).select('svg')
      svg.append('line')
        .attr('x1', 25)
        .attr('y1', 15)
        .attr('x2', 25)
        .attr('y2', 15)
        .attr("stroke-width", 2)
        .attr("stroke", "black")
        .transition()
        .duration(1500)
        .attr('x2', 400)
        .attr('y2', 150)
        .attr('fill', '#000000')
    }
  }
}
</script>

<style scoped lang="scss">
</style>
