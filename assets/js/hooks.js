import LineChart from "./line-chart"

let Hooks = {};

Hooks.LineChart = {
  mounted() {
    const { suggestedmin, suggestedmax } = JSON.parse(this.el.dataset.chartData)

    this.chart = new LineChart(this.el, suggestedmin, suggestedmax)

    this.handleEvent("new-point", ({ label, value, name }) => {
      this.chart.addPoint(label, value, name)
    })
  }
}

export default Hooks;