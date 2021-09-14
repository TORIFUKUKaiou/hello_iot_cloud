import Chart from "chart.js";

class LineChart {
  constructor(ctx, suggestedmin, suggestedmax) {
    this.chart = new Chart(ctx, {
      type: "line",
      data: {
        labels: [1,2,3,4,5,6,7,8,9,11,12],
        datasets: [
        ],
      },
      options: {
        scales: {
          xAxes: [
            {
              ticks: {
                fontStyle: "bold",
                fontSize: 14,
              },
            },
          ],
          yAxes: [
            {
              ticks: {
                suggestedMin: suggestedmin,
                suggestedMax: suggestedmax,
                fontStyle: "bold",
                fontSize: 14,
              },
            },
          ],
        },
      },
    });
  }

  addPoint(label, value, name) {
    const colors = [
      'rgb(128, 128, 0)',
      'rgb(255, 255, 0)',
      'rgb(255, 0, 255)',
      'rgb(192, 192, 192)',
      'rgb(0, 255, 255)',
      'rgb(0, 255, 0)',
      'rgb(255, 0, 0)',
      'rgb(128, 128, 128)',
      'rgb(0, 0, 255)',
      'rgb(0, 128, 0)',
      'rgb(128, 0, 128)',
      'rgb(0, 0, 0)',
      'rgb(0, 0, 128)',
      'rgb(0, 128, 128)',
      'rgb(128, 0, 0)',
    ]

    const labels = this.chart.data.labels;
    const datasets = this.chart.data.datasets;

    const names = datasets.map(function({label}) {
      return label;
    });
    const exists = names.some(function(n) {
      return n === name;
    });

    if (!exists) {
      datasets.push({label: name, data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], borderColor: colors[Math.floor(Math.random() * colors.length)]})
    }

    labels.push(label);

    const {data} = datasets.find(function({label}) {
      return label === name;
    });

    data.push(value);

    data.shift();
    labels.shift();

    this.chart.update();
  }
}

export default LineChart;