<template>
  <section class="chart">
    <svg width="710" height="250"></svg>
  </section>
</template>

<script>
import CurveNMoveAge from './d3.nmoveavg'
import helper_mixin from './helper_mixin'
const d3 = require('d3');

export default {
  mixins: [helper_mixin],
  props: ['frames', 'current'],
  mounted: function() {
    this.resetLinechart()
  },

  watch: {
    current: function() {
      this.moveCurrentPoint()
    },
    frames: function(newValue) {
      this.redrawToday(newValue[0])
    }
  },

  methods: {
    redrawToday: function(frames) {
      this.frames[0] = frames
      this.todaysPath
        .data([frames])
        .attr('d', this.line.curve(CurveNMoveAge.N(3)))
    },
    movingLineCountAverageAt: function(frame) {
      let points = [this.frames[0][frame], this.frames[0][frame-1], this.frames[0][frame-2]]
      points = points.filter(p => p).map(p => p.line_count)
      return points.reduce((a, b) => a + b, 0) / points.length
    },
    resetLinechart: function() {
      let that = this
      let svg = d3.select(this.$el).select('svg')
      this.svg = svg

      let generateData = function(daysData, dayOffset=0) {
        return daysData.map(function(f) {
          let tweakedDate = new Date(f.created_at)
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
      let x = this.x = d3.scaleTime().range([0, 700]);
      let y = this.y = d3.scaleLinear().range([200, 0])
      let xAxis = d3.axisBottom(x).ticks(6);

      let line = this.line = d3.line()
        .x(d => x(new Date(d.created_at)))
        .y(d => y(+d.line_count))

      // Scale the range of the data, and ensure end of range is end of day.
      let range = d3.extent(daysData[0], function(d) { return d.created_at; });
      let end = new Date(range[1]);
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
     this.todaysPath = svg.append('path')
       .data([daysData[0]])
       .attr("stroke-width", 2)
       .attr("stroke", "#0bf6bb")
       .attr("fill", "none")
       .attr('class', 'currentline')
       .attr('d', line.curve(CurveNMoveAge.N(3)))

      svg.append("g")
        .attr("class", "xaxis")
        .attr("transform", "translate(0, 220)")
        .call(xAxis)

      if(this.current && !this.current.closed) {
        // Draw circle at current spot
        let point = this.getCurrentPoint()
        this.circle = svg.append("circle")
          .attr("cx", point.x)
          .attr("cy", point.y)
          .attr("r", 5)
          .style("fill", "#0bf6bb")
          .style("stroke", "#fff")
          .style("stroke-width", 2)
      }

      // Handle Mouse
      let focus = svg.append("g")
        .attr("class", "focus")
        .style("display", "none");

      focus.append("circle")
        .style("fill", "white")
        .style("stroke", "#0bf6bb")
        .style("stroke-width", 2)
        .attr("r", 4.5);

      focus.append("text")
        .attr("x", 9)
        .attr("dy", ".35em");

      svg.on("mouseover", () => focus.style("display", null))
        .on("mouseout", () => focus.style("display", "none"))
        .on("mousemove", mousemove)
        .on("click", mouseclick)

      let bisectDate = d3.bisector((d, x) => d.created_at - x).left;
      function mouseToFrame(mouse) {
        let todaysData = generateData(that.frames[0]);
        let mouseDate = x.invert(d3.mouse(mouse)[0])
        return bisectDate(todaysData, mouseDate, 0, todaysData.length-1)
      }

      function mousemove() {
        let todaysData = generateData(that.frames[0]);
        let frame = mouseToFrame(this)
        let d = Object.assign({}, todaysData[frame])
        d.display = Math.round(d.line_count)
        d.line_count = that.movingLineCountAverageAt(frame)
        focus.attr("transform", "translate(" + x(d.created_at) + "," + y(d.line_count) + ")");
        focus.select("text").text(d.display);
      }

      function mouseclick() {
        that.$router.push(`/dates/${that.date}/frames/${mouseToFrame(this)}`)
      }
    },
    moveCurrentPoint: function() {
      let point = this.getCurrentPoint()
      this.circle.transition().duration(500)
        .attr("cx", point.x)
        .attr("cy", point.y);
    },
    getCurrentPoint: function() {
      return {
        x: this.x(new Date(this.current.created_at)),
        y: this.y(this.movingLineCountAverageAt(this.currentFrameIndex)),
        display: Math.round(this.current.line_count)
      }
    }
  }
}
</script>

<style lang="scss">
#shakecam .chart {
  svg:hover {
    cursor: pointer;
  }

  .xaxis line,
  .xaxis path {
    stroke: #b2b2b2;
  }

  .xaxis text {
    fill: #b2b2b2;
  }
}
</style>
