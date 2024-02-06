/*

// Set new default font family and font color to mimic Bootstrap's default styling
Chart.defaults.global.defaultFontFamily = 'Nunito', '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
Chart.defaults.global.defaultFontColor = '#858796';

// Pie Chart Example
var ctx = document.getElementById("myPieChart");

if (ctx !== null) {
    var myPieChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ["Exitosas", "Pendientes", "Errores"],
            datasets: [{
                    data: [45, 51, 4],
                    backgroundColor: ['#1cc88a', '#f6c23e', '#e74a3b'],
                    hoverBackgroundColor: ['#21eba2', '#f5d687', '#ed7a6f'],
                    hoverBorderColor: "rgba(234, 236, 244, 1)",
                }],
        },
        options: {
            maintainAspectRatio: false,
            tooltips: {
                backgroundColor: "rgb(255,255,255)",
                bodyFontColor: "#858796",
                borderColor: '#dddfeb',
                borderWidth: 1,
                titleSpacing: 0,
                footerSpacing: 6,
                footerMarginTop: 10,
                bodySpacing: 10,
                //xPadding: 15,
                //yPadding: 0,
                displayColors: false,
                //caretPadding: 10,
                callbacks: {
                    title: function (tooltipItem, data) {
                        return data.labels[tooltipItem[0].index];
                    },
                    label: function (tooltipItem, data) {
                        var amount = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
                        return amount + '%';
                    },
                },
            },
            legend: {
                display: false
            },
            cutoutPercentage: 60,
        },
    });
}

*/