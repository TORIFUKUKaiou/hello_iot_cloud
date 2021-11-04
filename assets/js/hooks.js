import LineChart from "./line-chart"

let Hooks = {};

Hooks.LineChart = {
  mounted() {
    const { suggestedmin, suggestedmax } = JSON.parse(this.el.dataset.chartData)

    this.chart = new LineChart(this.el, suggestedmin, suggestedmax)

    this.handleEvent("new-point", ({ label, value, name }) => {
      this.chart.addPoint(label, value, name)
    })

    this.handleEvent("new-points", ({ label, values, names }) => {
      this.chart.addPoints(label, values, names)
    })

    this.handleEvent("new-points-points", ({ temperature_points, humidity_points }) => {
      if (this.el.id === temperature_points.id) {
        const { label, values, names } = temperature_points
        this.chart.addPoints(label, values, names)
      }

      if (this.el.id === humidity_points.id) {
        const { label, values, names } = humidity_points
        this.chart.addPoints(label, values, names)
      }
    })
  }
}

export default Hooks;