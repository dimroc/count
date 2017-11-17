<template>
  <section class="chart">
    <svg width="710" height="250"></svg>
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
      current: { closed: true }
    }
  },

  watch: {
    frames: function(newValue) {
      this.resetLinechart()
    }
  },

  methods: {
    resetLinechart: function() {
      this.current = this.frames[0][0]
      let svg = d3.select(this.$el).select('svg')

      var generateData = function(daysData, dayOffset) {
        return daysData.map(function(f) {
          var tweakedDate = new Date(f.created_at)
          tweakedDate.setDate(tweakedDate.getDate() + dayOffset)
          return {
            created_at: tweakedDate,
            crowd_count: parseFloat(f.crowd_count),
            line_count: parseFloat(f.line_count)
          }
        });
      };

      let daysData = this.frames.map(function(daysFrames, idx) {
        return generateData(daysFrames, idx);
      });

      // Handle Axis
      var x = d3.scaleTime().range([0, 700]);
      var y = d3.scaleLinear().range([200, 0])
      var xAxis = d3.axisBottom(x)

      var line = d3.line()
        .x(function(d) { return x(d.created_at); })
        .y(function(d) { return y(d.line_count); });

      // Scale the range of the data, and ensure end of range is end of day.
      var range = d3.extent(daysData[0], function(d) { return d.created_at; });
      var end = new Date(range[1]);
      end.setHours(23);
      end.setMinutes(59);
      x.domain([range[0], end]);
      y.domain([0, 70]);

      // Draw previous days
      daysData.slice(1).forEach(function(day) {
        svg.append('path')
          .data([day])
          .attr("stroke-width", 1)
          .attr("stroke", "#aaa")
          .style("stroke-dasharray", ("2, 3"))
          .attr("fill", "none")
          .attr('class', 'previousline')
          .attr('d', line.curve(CurveNMoveAge.N(3)))
      });

      // Draw today
     svg.append('path')
       .data([daysData[0]])
       .attr("stroke-width", 2)
       .attr("stroke", "#0bf6bb")
       .attr("fill", "none")
       .attr('class', 'line')
       .attr('d', line.curve(CurveNMoveAge.N(3)))

      svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0, 220)")
        .call(xAxis)
    }
  }
}
</script>

<style scoped lang="scss">
</style>
