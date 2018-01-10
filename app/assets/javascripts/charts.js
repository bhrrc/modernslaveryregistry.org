function renderDonut(containerId, percentage) {
  var $container = $(document.getElementById(containerId));
  var $canvas = $container.find("canvas");
  new Chart($canvas[0].getContext("2d"), {
    type: "doughnut",
    data: {
      datasets: [
        {
          data: [percentage, 100 - percentage],
          backgroundColor: ["rgba(0,137,134,1)", "rgba(0,0,0,0)"],
          borderColor: ["rgba(0,137,134,1)", "rgba(0,137,134,1)"]
        }
      ]
    },
    options: {
      rotation: Math.PI,
      cutoutPercentage: 75,
      responsive: false
    }
  });
  $container.find(".donut-label").text(percentage + "%");
}

