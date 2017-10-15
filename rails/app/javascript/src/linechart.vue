<template>
  <section class="chart">
    <svg width="700" height="300"></svg>
    <h1>{{current_line_count | round}}</h1>
    <h4>People in line</h4>
  </section>
</template>

<script>
import Vue from 'vue'
import CurveNMoveAge from './d3.nmoveavg'
const d3 = require('d3');

export default {
  props: ['frames'],
  mounted: function() {
    this.resetLinechart()
  },
  data: function() {
    return {
      current_line_count: null
    }
  },
  watch: {
    frames: function(newValue) {
      this.resetLinechart()
    }
  },
  methods: {
    resetLinechart: function() {
      this.current_line_count = this.frames[0].line_count
      let svg = d3.select(this.$el).select('svg')

      var data = this.frames.map(function(f) {
        return {
          created_at: d3.isoParse(f.created_at),
          crowd_count: parseFloat(f.crowd_count),
          line_count: parseFloat(f.line_count)
        }
      });

      // Handle Axis
      var x = d3.scaleTime().range([0, 650]);
      var y = d3.scaleLinear().range([250, 0])
      var xAxis = d3.axisBottom(x)

      var line = d3.line()
        .x(function(d) { return x(d.created_at); })
        .y(function(d) { return y(d.line_count); });

      // Scale the range of the data
      x.domain(d3.extent(data, function(d) { return d.created_at; }));
      y.domain([0, 80]);

      // Draw everything
      svg.append('path')
        .data([data])
        .attr("stroke-width", 2)
        .attr("stroke", "black")
        .attr("fill", "none")
        .attr('class', 'line')
        .attr('d', line.curve(CurveNMoveAge.N(3)))

      svg.append("g").attr("class", "y axis").call(d3.axisLeft(y))

      svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0, 250)")
        .call(xAxis)
    }
  }
}
</script>

<style scoped lang="scss">
section.chart {
  margin-top: 30px;
}
</style>
