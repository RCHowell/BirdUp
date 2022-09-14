
var stationId = getURLParameter('id'); // http://192.168.1.105/wxstn/wx.html?id=14019443

var ws   = null; // WebSocket
var logm = null; // Logging list

var chartT; // Temperature
var chartP; // Pressure
var chartV; // Humidity
var chartW; // Windspeed
var chartD; // Wind direction

var xTs  = []; // x:timestamps

var dpsT  = []; // y:Temperatures
var dpsP  = []; // y:Pressures
var dpsH  = []; // y:Humidities
var dpsWS = []; // y:Windspeeds
var dpsDR = []; // y:Wind directions

var lastNum    = "#"; // Last packet number received
var chartBytes = 0;   // Data bytes from the websocket server to produce the charts

var doRender = true;


// Application entry point
function main() {
  if (!("WebSocket" in window)) {
    alert("This browser does not support WebSockets");
    return;
  }

  logm = document.getElementById("logm");

  createCharts();
  connect(true); // Connect and backfill
  setInterval(function() { checkConnection(); }, 1000);

  // Stop rendering the charts if the tab isn't visible
  document.addEventListener("visibilitychange", function() {
    if (document.visibilityState === "visible") { doRender = true;  }
    if (document.visibilityState === "hidden")  { doRender = false; }
  });
}


// Check if the websocket connection is still open and reconnect if not
function checkConnection() { if (ws == null) { connect(false); } }


// Create the charts
function createCharts() {
//    Chart.defaults.global.responsive = false;
  Chart.defaults.global.maintainAspectRatio = false;
  Chart.defaults.global.tooltips.enabled    = false;

  chartT = new Chart(document.getElementById("chartContainerT"), {
   type: "line",
   data: {
     labels: xTs,
     datasets: [
       {
         fill:             false,
         borderWidth:      0.5,
         borderColor:      "rgba(0, 0, 0, 1)",
         pointRadius:      0,
         pointHoverRadius: 0,
         lineTension:      0,
         data:             dpsT
       }
     ],
   },
   options: {
     title: {
       display: true,
       text:    "Temperature"
     },
     scales: {
       xAxes: [
         {
           type: "time",
           ticks: {
             fontSize:    10,
             maxRotation:  0
           },
           time: {
             displayFormats: { millisecond: "H:mm",  second: "H:mm", minute: "H:mm"}
           }
         }
       ],
       yAxes: [
         {
           scaleLabel: {
             display:     true,
             labelString: "\u00b0C",
           },
           position: "right",
           ticks: {
             fontSize:    10
           }
         }
       ]
     },
     legend: { display: false }
   }
  });

  chartP = new Chart(document.getElementById("chartContainerP"), {
    type: "line",
    data: {
      labels: xTs,
      datasets: [
        {
          fill:             false,
          borderWidth:      0.5,
          borderColor:      "rgba(0, 0, 0, 1)",
          pointRadius:      0,
          pointHoverRadius: 0,
          lineTension:      0,
          data:             dpsP
        }
      ],
    },
    options: {
      title: {
        display: true,
        text:    "Pressure"
      },
      scales: {
        xAxes: [
          {
            type: "time",
            ticks: {
              fontSize:    10,
              maxRotation:  0
            },
            time: {
              displayFormats: { millisecond: "H:mm",  second: "H:mm", minute: "H:mm"}
            }
          }
        ],
        yAxes: [
          {
            scaleLabel: {
              display:     true,
              labelString: "mBar",
            },
            position: "right",
            ticks: {
              fontSize:    10
            }
          }
        ]
      },
      legend: { display: false }
    }
  });

  chartH = new Chart(document.getElementById("chartContainerH"), {
    type: "line",
    data: {
      labels: xTs,
      datasets: [
        {
          fill:             false,
          borderWidth:      0.5,
          borderColor:      "rgba(0, 0, 0, 1)",
          pointRadius:      0,
          pointHoverRadius: 0,
          lineTension:      0,
          data:             dpsH
        }
      ],
    },
    options: {
      title: {
        display: true,
        text:    "Humidity"
      },
      scales: {
        xAxes: [
          {
            type: "time",
            ticks: {
              fontSize:    10,
              maxRotation:  0
            },
            time: {
              displayFormats: { millisecond: "H:mm",  second: "H:mm", minute: "H:mm"}
            }
          }
        ],
        yAxes: [
          {
            scaleLabel: {
              display:     true,
              labelString: "%",
            },
            position: "right",
            ticks: {
              fontSize:    10
            }
          }
        ]
      },
      legend: { display: false }
    }
  });

  chartW = new Chart(document.getElementById("chartContainerW"), {
    type: "line",
    data: {
      labels: xTs,
      datasets: [
        {
          fill:             false,
          borderWidth:      0.5,
          borderColor:      "rgba(0, 0, 0, 1)",
          pointRadius:      0,
          pointHoverRadius: 0,
          lineTension:      0,
          data:             dpsWS
        }
      ],
    },
    options: {
      title: {
        display: true,
        text:    "Windspeed"
      },
      scales: {
        xAxes: [
          {
            type: "time",
            ticks: {
              fontSize:    10,
              maxRotation:  0
            },
            time: {
              displayFormats: { millisecond: "H:mm",  second: "H:mm", minute: "H:mm"}
            }
          }
        ],
        yAxes: [
          {
            scaleLabel: {
              display:     true,
              labelString: "kph",
            },
            position: "right",
            ticks: {
              fontSize:    10
            }
          }
        ]
      },
      legend: { display: false }
    }
  });

  chartD = new Chart(document.getElementById("chartContainerD"), {
    type: "scatter",
    data: {
      labels: xTs,
      datasets: [
        {
          fill:             false,
          borderWidth:      0.5,
          borderColor:      "rgba(0, 0, 0, 1)",
          pointRadius:      1.75,
          pointHoverRadius: 0,
          lineTension:      0,
          data:             dpsDR
        }
      ],
    },
    options: {
      title: {
        display: true,
        text:    "Wind Direction"
      },
      scales: {
        xAxes: [
          {
            type: "time",
            ticks: {
              fontSize:    10,
              maxRotation:  0
            },
            time: {
              displayFormats: { millisecond: "H:mm",  second: "H:mm", minute: "H:mm"}
            }
          }
        ],
        yAxes: [
          {
            scaleLabel: {
              display:     true,
              labelString: "\u00b0",
            },
            position: "right",
            ticks: {
              fontSize:    10,
              min:          0,
              max:        360,
              stepSize:    45
            }
          }
        ]
      },
      legend: { display: false }
    }
  });
} // createObjects


// Connect to the websocket server
function connect(firstTime) {
  ws = new WebSocket((location.protocol === "http:" ? "ws:" : "wss:") + "//" + window.location.host + "/wxstn/ws");

  ws.onopen = function() { // Connected
    document.getElementById("connInd").className = "green";

    if (firstTime) {
      ws.send("bkwx:" + stationId + ":4hour"); // Request backfill data blob
    } else {
      ws.send("stwx:" + stationId);            // Request to start receiving station data now that the chart is backfilled
    }
  };

  ws.onclose = function(event) { // Server closed the socket or the socket timed out
    ws = null;
    document.getElementById("connInd").className = "red";
  };

//  ws.onerror = function(error) { // Something bad happened
//    addLine(logm, 50, "<b>Monitor</b>: " + timeStamp() + " : WebSocket error - " + JSON.stringify(error));
//  };

  ws.onmessage = function(event) { // Got something
    if (event.data instanceof Blob) {

      // Blob containing binary data - all backfill values
      chartBytes += event.data.size;

      var fileReader = new FileReader();

      fileReader.onload = function() {
        var uint32Buffer  = new Uint32Array(this.result);
        var float32Buffer = new Float32Array(this.result);
           
        var idx = 0;

        while (idx < uint32Buffer.length) {
          var ts      = new Date(uint32Buffer[idx++] * 1000);
          var valT    =         float32Buffer[idx++];
          var valTMax =         float32Buffer[idx++];
          var valTMin =         float32Buffer[idx++];
          var valP    =         float32Buffer[idx++];
          var valH    =         float32Buffer[idx++];
          var valW    =         float32Buffer[idx++] * 1.6094; // MPH to KPH
          var valWMax =         float32Buffer[idx++] * 1.6094; // MPH to KPH
          var valD    =         float32Buffer[idx++];
          var valV    =         float32Buffer[idx++];
          var valVMax =         float32Buffer[idx++];
          var valVMin =         float32Buffer[idx++];
          var valA    =         float32Buffer[idx++];
          var valAMax =         float32Buffer[idx++];
          var valR    =         float32Buffer[idx++];
          var valEX   =         float32Buffer[idx++];
          var valED   =         float32Buffer[idx++];
          var valER   =         float32Buffer[idx++];

          xTs.push(ts);

          if (!((isNaN(valT))  || (   -50 >  valT ) || (valT  >=    50))) { dpsT.push (valT);  } else { dpsT.push (null); }
//          if (isNaN(valT)) { dpsT.push (null); } else { if (!(( -50    >  valT ) || (valT  >    50)   || (Math.abs(valT) < 1e-6))) { dpsT.push (valT);  } else { dpsT.push (null); addLine(logm, 50, "<b>Monitor</b>: " + timeStamp(ts) + " : Bad T  - " + valT);  }
  
          if (!((isNaN(valP))  || (  -850 >  valP ) || (valP  >=  1100))) { dpsP.push (valP);  } else { dpsP.push (null); }
          if (!((isNaN(valH))  || (  1e-6 >  valH ) || (valH  >    100))) { dpsH.push (valH);  } else { dpsH.push (null); }
          if (!((isNaN(valW))  || (     0 >  valW ) || (valW  >=   100))) { dpsWS.push (valW);  } else { dpsWS.push (null); }
          if (!((isNaN(valD))  || (isNaN(valW))  || (valW < 0.8)  ||
                                  (     0 >  valD ) || (valD  >    360))) { dpsDR.push (valD);  } else { dpsDR.push (null); }
          
//          if (isNaN(valD) || isNaN(valW) || valW < 0.8) {
//            dpsDR.push ({x: ts, y:null});
//          } else {
//            if (!((   0    >  valD ) || (valD  >   360)                             )) { dpsDR.push({x: ts, y: valD});  } else { dpsDR.push({x: ts, y: null}); addLine(logm, 50, "<b>Monitor</b>: " + timeStamp(ts) + " : Bad DR - " + valD);  }
//          }

//          if (!((isNaN(valT))  || ( -50    >  valT ) || (valT  >    50)   || (Math.abs(valT) < 1e-6))) { dpsT.push (valT);  } else { dpsT.push (null); addLine(logm, 50, "<b>Monitor</b>: " + timeStamp(ts) + " : Bad T  - " + valT);  }
//          if (!((isNaN(valP))  || ( 850    >= valP ) || (valP  >= 1100)))                              { dpsP.push (valP);  } else { dpsP.push (null); addLine(logm, 50, "<b>Monitor</b>: " + timeStamp(ts) + " : Bad P  - " + valP);  }
//          if (!((isNaN(valH))  || (   1e-6 >  valH ) || (valH  >   100)))                              { dpsH.push (valH);  } else { dpsH.push (null); addLine(logm, 50, "<b>Monitor</b>: " + timeStamp(ts) + " : Bad H  - " + valH);  }
//          if (!((isNaN(valW))  || (   0    >  valW ) || (valW  >   100)))                              { dpsWS.push(valW);  } else { dpsWS.push(null); addLine(logm, 50, "<b>Monitor</b>: " + timeStamp(ts) + " : Bad WS - " + valW);  }

//          if (!(                  (   0    >  valD ) || (valD  >   360)))                              { dpsDR.push({x: ts, y: valD});  } else { dpsDR.push({x: ts, y: null}); addLine(logm, 50, "<b>Monitor</b>: " + timeStamp(ts) + " : Bad DR - " + valD);  }
        } // while (idx < uint32Buffer.length)

        updateCharts();

        ws.send("stwx:" + stationId); // Request to start receiving weather data now that the chart is backfilled
      } // if (event.data instanceof Blob)

      fileReader.readAsArrayBuffer(event.data);
      return;
    } // ws.onmessage = function(event)

    chartBytes += event.data.length;

    var msgType = event.data.substring(0, 4);

    switch (msgType) {
    case "logm": // nodejs message
      addLine(logm, 50, "&nbsp;<b>nodejs</b>: " + timeStamp() + " : " + event.data.substring(5));
      break;

    case "stnm": // Station name
      document.title += " " + event.data.substring(5);
      document.getElementById("stationName").innerHTML = event.data.substring(5);
      break;

    case "data": // Weather station data
      var data = JSON.parse(event.data.substring(5)); // What were NaN in the server are null here
      addData(data);
      updateCharts();
      break;

    case "nodt": // No station data received
      addNullData();
      updateCharts();
      break;

    default:
      addLine(logm, 50, "<b>Monitor</b>: " + timeStamp() + " : Unknown server msg - " + event.data);
      break;
    } // switch(msgType)
  }; // ws.onmessage
} // connect


// Add station data
function addData(data) {
  var ts = new Date(data.ts);

  data.windspeed *= 1.6094; // MPH to KPH
  
  if ((data.temperature === null) || ( -50   >  data.temperature) || (data.temperature >    50))  { /* addLine(logm, 50, "<b>Monitor</b>: " + timeStamp(ts) + " : Temperature value bad : " + data.temperature); */ data.temperature = NaN; }
  if ((data.pressure    === null) || ( 850   >= data.pressure   ) || (data.pressure    >= 1100))  { /* addLine(logm, 50, "<b>Monitor</b>: " + timeStamp(ts) + " : Pressure value bad : "    + data.pressure   ); */ data.pressure    = NaN; }
  if ((data.humidity    === null) || (   0.1 >  data.humidity   ) || (data.humidity    >   100))  { /* addLine(logm, 50, "<b>Monitor</b>: " + timeStamp(ts) + " : Humidity value bad : "    + data.humidity   ); */ data.humidity    = NaN; }
  if ((data.windspeed   === null) || (   0   >  data.windspeed  ) || (data.windspeed   >   100))  { /* addLine(logm, 50, "<b>Monitor</b>: " + timeStamp(ts) + " : Windspeed value bad : "   + data.windspeed  ); */ data.windspeed   = NaN; }
  if ((data.direction   !== null) &&((   0   >  data.direction  ) || (data.direction   >   360))) { /* addLine(logm, 50, "<b>Monitor</b>: " + timeStamp(ts) + " : Direction value bad : "   + data.direction  ); */ data.direction   = NaN; }
  
  xTs.push(ts);

  dpsT.push (data.temperature);
  dpsP.push (data.pressure);
  dpsH.push (data.humidity);
  dpsWS.push(data.windspeed);
  
  if (data.windspeed > 0.8) {
    dpsDR.push({x: ts, y: data.direction});
  } else {
    dpsDR.push({x: ts, y: null});
  }

  document.getElementById("valN").innerHTML = data.num + " " + timeStamp(data.ts) + " " + uptime(data.num);
  document.getElementById("valT").innerHTML = data.temperature.toFixed(2);
  document.getElementById("valP").innerHTML = data.pressure.toFixed(2);
  document.getElementById("valH").innerHTML = data.humidity.toFixed(2);
  document.getElementById("valW").innerHTML = data.windspeed.toFixed(1);

  if (data.direction !== null) {
    document.getElementById("valD").innerHTML = data.direction.toFixed(0);
  } else { // if (data.direction !== null)
    document.getElementById("valD").innerHTML = "#";
  } // if (data.direction !== null) else

  document.getElementById("valB").innerHTML = chartBytes;

  lastNum = data.num;
}


// Add null data if a station has stopped sending
function addNullData() {
  var ts = new Date();

  xTs.push(ts);

  dpsT.push(null);
  dpsP.push(null);
  dpsH.push(null);
  dpsWS.push(null);
  dpsDR.push({x: ts, y: null});

  document.getElementById("valN").innerHTML = lastNum + " " + timeStamp(ts) + " " + uptime(lastNum);
  document.getElementById("valT").innerHTML = "#.##";
  document.getElementById("valP").innerHTML = "#.##";
  document.getElementById("valH").innerHTML = "#.##";
  document.getElementById("valW").innerHTML = "#";
  document.getElementById("valD").innerHTML = "#";
  document.getElementById("valB").innerHTML = chartBytes;
}


// Removes old data and renders the charts
function updateCharts() {
  var back4hours = new Date();
  back4hours.setHours(back4hours.getHours() - 4);
//  back4hours.setMinutes(back4hours.getMinutes() - 5);

  while (xTs.length > 0 && xTs[0] < back4hours) {
    xTs.shift();

    dpsT.shift();
    dpsP.shift();
    dpsH.shift();
    dpsWS.shift();
    dpsDR.shift();
  }

  if (doRender === true) {
    chartT.update(0);
    chartP.update(0);
    chartH.update(0);
    chartW.update(0);
    chartD.update(0);
  }
}


// Adds a line to a list
function addLine(ulObject, lineLimit, line) {
  while (ulObject.childElementCount >= lineLimit) { ulObject.removeChild(ulObject.firstElementChild); }

  var li = document.createElement("li");

  li.innerHTML = line;
  li.className = "liline";

  ulObject.appendChild(li);
}


// Returns a timestamp string
function timeStamp() {
  var ts;

  if (arguments.length == 0) { ts = new Date(); }
  else                       { ts = new Date(arguments[0]); }

  return ts.getFullYear() + "/" + pad(ts.getMonth() + 1, 2) + "/" + pad(ts.getDate(), 2) + " " +
         pad(ts.getHours(), 2) + ":" + pad(ts.getMinutes(), 2) + ":" + pad(ts.getSeconds(), 2);
}


// Returns an uptime string from the packet number
function uptime(packetNum) {
  var secs  = packetNum * 3;
  var days  = Math.floor(secs / (24 * 60 * 60)); secs -=  days * (24 * 60 * 60);
  var hours = Math.floor(secs / (     60 * 60)); secs -= hours * (     60 * 60);
  var mins  = Math.floor(secs / (          60)); secs -=  mins * (          60);
  
  return days + "d" + pad(hours, 2) + ":" + pad(mins, 2) + ":" + pad(secs, 2);
}


// Returns a left zero padded number string
function pad(num, size) {
  var s = "00000000" + num;
  return s.substr(s.length - size);
}


// Returns a parameter from the page URL
function getURLParameter(sParam) {
  var sPageURL      = window.location.search.substring(1);
  var sURLVariables = sPageURL.split('&');

  for (var i = 0, len = sURLVariables.length; i < len; ++i) {
    var sParameterName = sURLVariables[i].split('=');

    if (sParameterName[0] == sParam) {
      return sParameterName[1];
    }
  }
}

