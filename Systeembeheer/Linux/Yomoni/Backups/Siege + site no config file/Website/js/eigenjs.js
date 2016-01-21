// On document ready, call visualize on the datatable.
$(document).ready(function() {

$("#active").load("../menu-t.html");

$("#activei").load("menu-i.html");

  var kk = new Highcharts.Chart({
           data: {
            table: document.getElementById('transdata'),
        },
         chart: {
            renderTo: 'translijntje',
            type: 'line'
        },
        title: {
            text: 'Transactions',
            style: {
                color: 'black',
                fontSize: '16px',
                fontWeight: 'bold'
            }
        },
        xAxis: {
            title: {
                text: 'number of concurring users'
            }
        },
        legend: {
            itemStyle: {
                fontWeight: 'bold',
                fontSize: '13px'
            }
        },
        tooltip: {
            formatter: function() {
                return '<b>'+ this.series.name +'</b><br/>'+
                    this.y +' '+ this.x.toLowerCase();
            }
        },
        plotOptions: {
            line: {
                    dataLabels: {
                    enabled: true
                },
            enableMouseTracking: false
        },
        series: {
            shadow: true,
             type: 'line'
        },
       navigator: {
            xAxis: {
                gridLineColor: '#D0D0D8'
                }
        },
        rangeSelector: {
            buttonTheme: {
                fill: 'white',
                stroke: '#C0C0C8',
                'stroke-width': 1,
            states: {
                select: {
                    fill: '#D0D0D8'
                    }
                }
            }
        },
        scrollbar: {
            trackBorderColor: '#C0C0C8'
        },
        candlestick: {
            lineColor: '#404048'
        },
        map: {
            shadow: false
            }
        },
        colors:["#f45b5b", "#8085e9", "#8d4654", "#7798BF", "#aaeeee", "#ff0066", "#eeaaee",
      "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"],
        
        background2: '#E0E0E8'
        });

var ch = new Highcharts.Chart({
        data: {
            table: document.getElementById('failorsuc'),
        },
        chart: {
            type: 'pie',
            renderTo: 'failsucces',
            plotBackgroundColor: null,
            plotBorderWidth: 0,
            plotShadow: false,
            margin: 0 
        },
        title: {
            text: 'Success / Fail Ratio',
            align: 'center',
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                dataLabels: {
                    enabled: false,
                    distance: -50,
                    style: {
                        fontWeight: 'bold',
                        color: 'white',
                        textShadow: '0px 1px 2px black'
                    }
                },
                startAngle: -90,
                endAngle: 90,
                center: ['50%', '75%']
            },
                        series: {
                dataLabels: {
                    enabled: true,
                    formatter: function() {
                        return Math.round(this.percentage*100)/100 + ' %';
                    },
                    distance: -30,
                    color:'white'
                }
            }
        },
        colors:["#55BF3B", "#f45b5b"],
    });

Highcharts.visualize = function(table, options, rijke) {
        // the categories
        options.xAxis.categories = [];
        $('tbody th', table).each( function(i) {
            options.xAxis.categories.push(this.innerHTML);
        });

        // the data series
        options.series = [];
        $('tr', table).each( function(i) {
            var tr = this;
            $('th, td', tr).each( function(j) {
                if (j == rijke) { // skip first column
                    if (i == 0) { // get the name and init the series
                        options.series[0] = {
                            name: this.innerHTML,
                            data: []
                        };
                    } else { // add values
                        options.series[0].data.push(parseFloat(this.innerHTML));
                    }
                }
            });
        });

   var chart = new Highcharts.Chart(options);
}

Highcharts.visualizeTrans = function(table, options, rijke1, rijke2, rijke3) {
        // the categories
        options.xAxis.categories = [];
        $('tbody th', table).each( function(i) {
            options.xAxis.categories.push(this.innerHTML);
        });

        // the data series
        options.series = [];
        $('tr', table).each( function(i) {
            var tr = this;
            $('th, td', tr).each( function(j) {
                    if (i == rijke1 || i == rijke2 || i == rijke3) {
                        if(i == rijke1){
                        options.series[0] = {
                            name: this.innerHTML,
                            data: []
                        };
                    }
                    if(i == rijke2){
                        options.series[1] = {
                            name: this.innerHTML,
                            data: []
                        };
                    }
                    if(i == rijke3){
                        options.series[2] = {
                            name: this.innerHTML,
                            data: []
                        };
                    }


                    } else { // add values
                        options.series[0].data.push(parseFloat(this.innerHTML));
                    }
            });
        });

   var chart = new Highcharts.Chart(options);
}

var table = document.getElementById('datatable'),
    elap = {
        chart: {
            renderTo: 'elapsedtime',
            type: 'line'
        },
        title: {
            text: 'Elapsed time',
            style: {
                color: 'black',
                fontSize: '16px',
                fontWeight: 'bold'
            }
        },
        xAxis: {
            title: {
                text: 'number of concurring users'
            }
        },
        legend: {
            itemStyle: {
                fontWeight: 'bold',
                fontSize: '13px'
            }
        },
        yAxis: {
            title: {
                text: 'Time in Seconds'
            }
        },
        tooltip: {
            formatter: function() {
                return '<b>'+ this.series.name +'</b><br/>'+
                    this.y +' '+ this.x.toLowerCase();
            }
        },
        plotOptions: {
            line: {
                    dataLabels: {
                    enabled: true
                },
            enableMouseTracking: false
        },
        series: {
            shadow: true
        },
       navigator: {
            xAxis: {
                gridLineColor: '#D0D0D8'
                }
        },
        rangeSelector: {
            buttonTheme: {
                fill: 'white',
                stroke: '#C0C0C8',
                'stroke-width': 1,
            states: {
                select: {
                    fill: '#D0D0D8'
                    }
                }
            }
        },
        scrollbar: {
            trackBorderColor: '#C0C0C8'
        },
        candlestick: {
            lineColor: '#404048'
        },
        map: {
            shadow: false
            }
        },
        colors:["#f45b5b", "#8085e9", "#8d4654", "#7798BF", "#aaeeee", "#ff0066", "#eeaaee",
      "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"],
        
        background2: '#E0E0E8'
        };

var table = document.getElementById('datatable'),
    resp = {
        chart: {
            renderTo: 'responsetime',
            type: 'line'
        },
        title: {
            text: 'Response time',
            style: {
                color: 'black',
                fontSize: '16px',
                fontWeight: 'bold'
            }
        },
        subtitle: {
    text: '0 represents NAN!'
        },
        xAxis: {
            title: {
                text: 'number of concurring users'
            }
        },
        legend: {
            itemStyle: {
                fontWeight: 'bold',
                fontSize: '13px'
            }
        },
        yAxis: {
            title: {
                text: 'Time in Seconds'
            }
        },
        tooltip: {
            formatter: function() {
                return '<b>'+ this.series.name +'</b><br/>'+
                    this.y +' '+ this.x.toLowerCase();
            }
        },
        plotOptions: {
            line: {
                    dataLabels: {
                    enabled: true
                },
            enableMouseTracking: false
        },
        series: {
            shadow: true
        },
       navigator: {
            xAxis: {
                gridLineColor: '#D0D0D8'
                }
        },
        rangeSelector: {
            buttonTheme: {
                fill: 'white',
                stroke: '#C0C0C8',
                'stroke-width': 1,
            states: {
                select: {
                    fill: '#D0D0D8'
                    }
                }
            }
        },
        scrollbar: {
            trackBorderColor: '#C0C0C8'
        },
        candlestick: {
            lineColor: '#404048'
        },
        map: {
            shadow: false
            }
        },
        colors:["#8085e9", "#8d4654", "#7798BF", "#aaeeee", "#ff0066", "#eeaaee",
      "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"],
        
        background2: '#E0E0E8'
        };

var table = document.getElementById('datatable'),
    transrate = {
        chart: {
            renderTo: 'transactionrate',
            type: 'line'
        },
        title: {
            text: 'Transaction rate',
            style: {
                color: 'black',
                fontSize: '16px',
                fontWeight: 'bold'
            }
        },
        xAxis: {
            title: {
                text: 'number of concurring users'
            }
        },
        legend: {
            itemStyle: {
                fontWeight: 'bold',
                fontSize: '13px'
            }
        },
        yAxis: {
            title: {
                text: ''
            }
        },
        tooltip: {
            formatter: function() {
                return '<b>'+ this.series.name +'</b><br/>'+
                    this.y +' '+ this.x.toLowerCase();
            }
        },
        plotOptions: {
            line: {
                    dataLabels: {
                    enabled: true
                },
            enableMouseTracking: false
        },
        series: {
            shadow: true
        },
       navigator: {
            xAxis: {
                gridLineColor: '#D0D0D8'
                }
        },
        rangeSelector: {
            buttonTheme: {
                fill: 'white',
                stroke: '#C0C0C8',
                'stroke-width': 1,
            states: {
                select: {
                    fill: '#D0D0D8'
                    }
                }
            }
        },
        scrollbar: {
            trackBorderColor: '#C0C0C8'
        },
        candlestick: {
            lineColor: '#404048'
        },
        map: {
            shadow: false
            }
        },
        colors:["#8d4654", "#7798BF", "#aaeeee", "#ff0066", "#eeaaee",
      "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"],
        
        background2: '#E0E0E8'
        };

var table = document.getElementById('datatable'),
    trans = {
        chart: {
            renderTo: 'transactions',
            type: 'line'
        },
        title: {
            text: 'Transaction rate',
            style: {
                color: 'black',
                fontSize: '16px',
                fontWeight: 'bold'
            }
        },
        xAxis: {
            title: {
                text: 'number of concurring users'
            }
        },
        legend: {
            itemStyle: {
                fontWeight: 'bold',
                fontSize: '13px'
            }
        },
        yAxis: {
            title: {
                text: ''
            }
        },
        tooltip: {
            formatter: function() {
                return '<b>'+ this.series.name +'</b><br/>'+
                    this.y +' '+ this.x.toLowerCase();
            }
        },
        plotOptions: {
            line: {
                    dataLabels: {
                    enabled: true
                },
            enableMouseTracking: false
        },
        series: {
            shadow: true
        },
       navigator: {
            xAxis: {
                gridLineColor: '#D0D0D8'
                }
        },
        rangeSelector: {
            buttonTheme: {
                fill: 'white',
                stroke: '#C0C0C8',
                'stroke-width': 1,
            states: {
                select: {
                    fill: '#D0D0D8'
                    }
                }
            }
        },
        scrollbar: {
            trackBorderColor: '#C0C0C8'
        },
        candlestick: {
            lineColor: '#404048'
        },
        map: {
            shadow: false
            }
        },
        colors:["#8d4654", "#7798BF", "#aaeeee", "#ff0066", "#eeaaee",
      "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"],
        
        background2: '#E0E0E8'
        };













    Highcharts.visualize(table, elap, 2);
    Highcharts.visualize(table, resp, 3);
    Highcharts.visualize(table, transrate, 4);

});



