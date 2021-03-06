function showChart(url){
  $.getJSON(url, function( data ) {
    var carrier_data = data.carrier_stats;
    var benchmark_data = data.benchmark_stats;
    var bar_data = {
      labels: ["Average Departure Delay", "Average Taxi Out Time", "Average Arrival Delay", "Average Taxi In Time"],
      datasets: [
          {
              label: "Carrier",
              fillColor: "rgba(238, 21, 24,0.5)",
              strokeColor: "rgba(238, 21, 24,0.8)",
              highlightFill: "rgba(238, 21, 24,0.75)",
              highlightStroke: "rgba(238, 21, 24,1)",
              data: carrier_data.slice(1)
          },
          {
              label: "Benchmark",
              fillColor: "rgba(68, 162, 61,0.5)",
              strokeColor: "rgba(68, 162, 61,0.8)",
              highlightFill: "rgba(68, 162, 61,0.75)",
              highlightStroke: "rgba(68, 162, 61,1)",
              data: benchmark_data.slice(1)
          }
        ]
      };

    var colorPercentage = diffToPercent(carrier_data[0], benchmark_data[0]);
    var colorCheck = makeGradientColor(colorPercentage, 0.5);
    var cancel_data = {
      labels: ["Cancellation Rate"],
      datasets: [
          {
              label: "Carrier",
              fillColor: makeGradientColor(colorPercentage, 0.5),
              strokeColor: makeGradientColor(colorPercentage, 0.8),
              highlightFill: makeGradientColor(colorPercentage, 0.75),
              highlightStroke: makeGradientColor(colorPercentage, 1.0),
              data: [carrier_data[0]]
          },
          {
              label: "Benchmark",
              fillColor: "rgba(151,187,205,0.5)",
              strokeColor: "rgba(151,187,205,0.8)",
              highlightFill: "rgba(151,187,205,0.75)",
              highlightStroke: "rgba(151,187,205,1)",
              data: [benchmark_data[0]]
          }
        ]
      };
    var bar_ctx = $("#stat_chart").get(0).getContext("2d");
    bar_ctx.canvas.width = 600;
    bar_ctx.canvas.height = 500;
    var cancel_ctx = $("#cancel_rate").get(0).getContext("2d");
    cancel_ctx.canvas.width = 300;
    cancel_ctx.canvas.height = 500;
    var newChart = new Chart(bar_ctx).Bar(bar_data);
    var cancelChart = new Chart(cancel_ctx).Bar(cancel_data);
  });
}

function delayChart(){
  $.getJSON("/delay_chart", function( data ) {
    var labels = data.carriers;
    var departures = data.average_departure_delay;
    var arrivals = data.average_arrival_delay;
    var chart_data = {
      labels: labels,
      datasets: [
          {
              label: "Average Departure Delay",
              fillColor: "rgba(238, 21, 24,0.5)",
              strokeColor: "rgba(238, 21, 24,0.8)",
              highlightFill: "rgba(238, 21, 24,0.75)",
              highlightStroke: "rgba(238, 21, 24,1)",
              data: departures
          },
          {
              label: "Average Arrival Delay",
              fillColor: "rgba(68, 162, 61,0.5)",
              strokeColor: "rgba(68, 162, 61,0.8)",
              highlightFill: "rgba(68, 162, 61,0.75)",
              highlightStroke: "rgba(68, 162, 61,1)",
              data: arrivals
          }
        ]
      };
      var ctx = $("#delay_chart").get(0).getContext("2d");
      var newChart = new Chart(ctx).Bar(chart_data);
  });
}
function taxiChart(){
  $.getJSON("/taxi_chart", function( data ) {
    var labels = data.carriers;
    var taxiIn = data.average_taxi_in;
    var taxiOut = data.average_taxi_out;
    var chart_data = {
      labels: labels,
      datasets: [
          {
              label: "Taxi In Time",
              fillColor: "rgba(238, 21, 24,0.5)",
              strokeColor: "rgba(238, 21, 24,0.8)",
              highlightFill: "rgba(238, 21, 24,0.75)",
              highlightStroke: "rgba(238, 21, 24,1)",
              data: taxiIn
          },
          {
              label: "Taxi Out Time",
              fillColor: "rgba(68, 162, 61,0.5)",
              strokeColor: "rgba(68, 162, 61,0.8)",
              highlightFill: "rgba(68, 162, 61,0.75)",
              highlightStroke: "rgba(68, 162, 61,1)",
              data: taxiOut
          }
        ]
      };
      var ctx = $("#taxi_chart").get(0).getContext("2d");
      var newChart = new Chart(ctx).Bar(chart_data);
  });
}

function rateChart(){
  $.getJSON("/rate_chart", function( data ) {
    var labels = data.carriers;
    var cancellationRate = data.cancellation_rate;
    var departureRate = data.late_departure_rate;
    var lateArrivalRate = data.late_arrival_rate;
    var earlyArrivalRate = data.early_arrival_rate;
    var chart_data = {
      labels: labels,
      datasets: [
          {
              label: "Cancellation Rate",
              fillColor: "rgba(238, 21, 24,0.5)",
              strokeColor: "rgba(238, 21, 24,0.8)",
              highlightFill: "rgba(238, 21, 24,0.75)",
              highlightStroke: "rgba(238, 21, 24,1)",
              data: cancellationRate
          },
          {
              label: "Late Departure Rate",
              fillColor: "rgba(68, 162, 61,0.5)",
              strokeColor: "rgba(68, 162, 61,0.8)",
              highlightFill: "rgba(68, 162, 61,0.75)",
              highlightStroke: "rgba(68, 162, 61,1)",
              data: departureRate
          },
          {
              label: "Late Arrival Rate",
              fillColor: "rgba(111, 101, 20, 0.5)",
              strokeColor: "rgba(111, 101, 20, 0.8)",
              highlightFill: "rgba(111, 101, 20, 0.75)",
              highlightStroke: "rgba(111, 101, 20, 1)",
              data: lateArrivalRate
          },
        ]
      };
      var ctx = $("#rate_chart").get(0).getContext("2d");
      var newChart = new Chart(ctx).Bar(chart_data);
  });
}



$(function(){

  var id = window.location.href.match(/\/(\d+)\/?/);
  var url;
  if (id != null){
    url = "/carriers/" + id[1];
    $("#stat_chart").empty();
    $("#cancel_rate").empty();
    showChart(url);
  } else {
    $("#delay_chart").empty();
    $("#taxi_chart").empty();
    $("#rate_chart").empty();
    delayChart();
    taxiChart();
    rateChart();
  }
});
