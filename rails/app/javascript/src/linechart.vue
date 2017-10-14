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
//      svg.append('line')
//        .attr('x1', 25)
//        .attr('y1', 15)
//        .attr('x2', 25)
//        .attr('y2', 15)
//        .attr("stroke-width", 2)
//        .attr("stroke", "black")
//        .transition()
//        .duration(1500)
//        .attr('x2', 400)
//        .attr('y2', 150)
//        .attr('fill', '#000000')

      var y = d3.scaleLinear().range([0, 250])
      var x = d3.scaleTime()
        .domain([new Date(2017, 10, 13), new Date(2017, 10, 14)])
        .range([0, 650]);
      var xAxis = d3.axisBottom(x)
        .ticks(d3.timeHour.every(1))
        //makes the xAxis ticks a little longer than the xMinorAxis ticks
        //.tickSize(10);
//      var xMinorAxis = d3.svg.axis()
//        .scale(x)
//        .ticks(d3.time.hours,12)
//        .orient("bottom");
//
      svg.append("g").attr("class", "y axis").call(d3.axisLeft(y))
      svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0, 250)")
        .call(xAxis)
        .selectAll("text").remove()
//
//      svg.append("g")
//        .attr("class","xMinorAxis")
//        .attr("transform", "translate(0," + 300 + ")")
//        .style({ 'stroke': 'Black', 'fill': 'none', 'stroke-width': '1px'})
//        .call(xMinorAxis)
//        .selectAll("text").remove();
//
//      var line = d3.svg.line()
//        .x(function(d) { return x(d.created_at); })
//        .y(function(d) { return y(d.line_count); });
//
//      var data = [
//        {'x': 1, 'y': 3},
//        {'x': 20, 'y': 50},
//        {'x': 30, 'y': 37},
//        {'x': 40, 'y': 45},
//        {'x': 50, 'y': 39},
//      ];
//
//      var x_scale = d3.scale.linear().domain([0,6]).range([0, 960]);
//      var y_scale = d3.scale.linear().domain([0,6]).range([300, 0]);
//
//      var line = d3.svg.line()
//        .x(function(d) { return x_scale(d['x']); })
//        .y(function(d) { return y_scale(d['y']); });
//
//      // path vs. line
//      console.log(line(data));
//      d3.select('body').append('code').text('Line path data: ' + line(data));
//
//      var path = svg.append('path').attr('d', line(data))
//        .attr("stroke-width", 2)
//        .attr("stroke", "black")
    }
  }
}
</script>

<style scoped lang="scss">
</style>
