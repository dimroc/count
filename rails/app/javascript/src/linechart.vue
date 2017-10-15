<template>
  <section class="chart">
    <svg width="700" height="300"></svg>
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

      var data = this.frames.map(function(f) {
        return {
          created_at: d3.isoParse(f.created_at),
          crowd_count: parseFloat(f.crowd_count),
          line_count: parseFloat(f.line_count)
        }
      });

      console.log(data);

      var line = d3.line()
        .x(function(d) { return d.created_at; })
        .y(function(d) { return d.line_count; });

      // Handle Axis
      var x = d3.scaleTime().range([0, 650]);
      var y = d3.scaleLinear().range([0, 250])
      var xAxis = d3.axisBottom(x)//.ticks(d3.timeHour.every(1))

      // Scale the range of the data
      x.domain(d3.extent(data, function(d) { return d.created_at; }));
      y.domain([0, d3.max(data, function(d) { return d.line_count; })]);

      // Draw everything
      svg.append('path')
        .data([data])
        .attr("stroke-width", 2)
        .attr("stroke", "black")
        .attr('class', 'line')
        .attr('d', line)

      svg.append("g").attr("class", "y axis").call(d3.axisLeft(y))

      svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0, 250)")
        .call(xAxis)
        .selectAll("text").remove()
    }
  }
}
</script>

<style scoped lang="scss">
</style>
