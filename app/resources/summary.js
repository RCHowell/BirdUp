var units    = 'i';  // Default to imperial freedom units
var ws       = null; // WebSocket
var doRender = true;

var stationIds = [];

// Application entry point
function main() {
  if (!("WebSocket" in window)) {
    alert("This browser does not support WebSockets");
    return;
  }

  // Collect the requested station ids
  if (arguments.length < 2) { return; } // No stations requested

  units = arguments[0];

  for (var i = 1; i < arguments.length; i++) {
    stationIds.push(arguments[i]);
  }

  // Setup the elements for each station
  stationIds.forEach(function(id) {
    var n;
    var rose = document.getElementById("RoseContainer" + id);

    // Station name
    n = document.createElement("p");

    n.className = "stationName";
    n.id        = "stationName" + id;
    n.innerHTML = "_";

    n.addEventListener("click", gotoChart, false);

    rose.appendChild(n);

    // Compass
    var compass = document.createElement("div");

    compass.className = "compass";

    n = document.createElement("ul");

    n.className = "cardinal-points";
    n.innerHTML = "<li>N</li><li>NE</li><li>E</li><li>SE</li><li>S</li><li>SW</li><li>W</li><li>NW</li>";

    compass.appendChild(n);

    // Text elements
    var info = document.createElement("div");

    info.className = "info";

    // Units button
    n = document.createElement("p");

    n.className = "units";
    n.id        = "units" + id;
    n.innerHTML = units;
    n.addEventListener("click", changeUnits, false);

    info.appendChild(n); // Add the units button to the compass

    // Humidity
    n = document.createElement("p");

    n.className = "humidity";
    n.id        = "humidity" + id;
    n.innerHTML = "-%";

    info.appendChild(n);

    // Temperature
    n = document.createElement("p");

    n.className = "temperature";
    n.id        = "temperature" + id;
    n.innerHTML = "-&deg;" + (units == "m"? "C" : "F");

//      n.addEventListener("click", changeUnits, false); // ? Click temperature to change units? doesnt work?
//      addListener(n, "onclick", changeUnits);

    info.appendChild(n);

    // Direction text
    n = document.createElement("p");

    n.className = "txt";
    n.id        = "direction-txt" + id;
    n.innerHTML = "off";

    info.appendChild(n);

    // Windspeed
    n = document.createElement("p");

    n.className = "windspeed";
    n.id        = "windspeed" + id;
    n.innerHTML = "-" + (units == "m"? "kph" : "mph");

    info.appendChild(n);

    // Update time
    n = document.createElement("p");

    n.className = "time";
    n.id        = "time" + id;
    n.innerHTML = "--:--:--";

    info.appendChild(n); // Add the update time to the info

    compass.appendChild(info); // Add the info to the compass

    // Direction arrow
    n = document.createElement("div");

    n.className        = "arrow";
    n.id               = "compassarrow" + id;
    n.style.visibility = "hidden";

    compass.appendChild(n); // Add the direction arrow to the compass

    rose.appendChild(compass); // Add the compass to the rose
  });

  connect();
  setInterval(function() { checkConnection(); }, 1000);

  // Stop rendering the dials if the tab isn't visible
  document.addEventListener("visibilitychange", function() {
    if (document.visibilityState === "visible") { doRender = true;  }
    if (document.visibilityState === "hidden")  { doRender = false; }
  });
}


// Check if the websocket connection is still open and reconnect if not
function checkConnection() { if (ws == null) { connect(); } }


// Connect to the websocket server
function connect() {
  ws = new WebSocket((location.protocol === "http:" ? "ws:" : "wss:") + "//" + window.location.host + "/wxstn/ws");

  ws.onopen = function() { // Connected
    stationIds.forEach(function(id) {
      ws.send("stnm:" + id); // Request the station name
      ws.send("stwx:" + id); // Request to start receiving station data
    });
  };

  ws.onclose = function(event) { // Server closed the socket or the socket timed out
    ws = null;
  };

  ws.onmessage = function(event) { // Got something
    var msgType = event.data.substring(0, 4);

    switch (msgType) {
    case "stnm": // Station name
      var parts = event.data.substring(5).split(',');

      document.getElementById("stationName" + parts[0]).innerHTML = parts[1];
      break;

    case "data": // Weather station data
      var data = JSON.parse(event.data.substring(5)); // What were NaN in the server are null here
      addData(data);
      break;

    case "nodt": // Weather station data timeout - station gone
      var data = JSON.parse(event.data.substring(5));
      noData(data);
      break;

    default:
      break;
    } // switch(msgType)
  }; // ws.onmessage
} // connect


// Add station data
function addData(data) {
  var ts     = new Date(data.ts);
  var date   = new Date(ts);
  var txtdir = "off";
  var colors;

  data.windspeed *= 1.6094; // MPH to KPH

  if ((data.temperature === null) ||  ( -50   >  data.temperature) || (data.temperature >    50))  { data.temperature = NaN; }
  if ((data.pressure    === null) ||  ( 850   >= data.pressure   ) || (data.pressure    >= 1100))  { data.pressure    = NaN; }
  if ((data.humidity    === null) ||  (   0.1 >  data.humidity   ) || (data.humidity    >   100))  { data.humidity    = NaN; }
  if ((data.windspeed   === null) ||  (   0   >  data.windspeed  ) || (data.windspeed   >   100))  { data.windspeed   = NaN; }
  if ((data.direction   !== null) && ((   0   >  data.direction  ) || (data.direction   >   360))) { data.direction   = NaN; }

  document.getElementById("humidity" + data.id).style.color    = "black";
  document.getElementById("temperature" + data.id).style.color = "black";

  document.getElementById("humidity" + data.id).innerHTML = data.humidity.toFixed(0) + "%";
  document.getElementById("temperature" + data.id).innerHTML = (units == "m"? data.temperature.toFixed(1) + "&deg;C" : ((data.temperature * 9 / 5) + 32).toFixed(1) + "&deg;F");

  if (data.direction !== null && data.windspeed !== null) {
    if (data.direction >=   0.0 && data.direction <  22.5) { txtdir =  "N"; }
    if (data.direction >=  22.5 && data.direction <  67.5) { txtdir = "NE"; }
    if (data.direction >=  67.5 && data.direction < 112.5) { txtdir =  "E"; }
    if (data.direction >= 112.5 && data.direction < 157.5) { txtdir = "SE"; }
    if (data.direction >= 157.5 && data.direction < 202.5) { txtdir =  "S"; }
    if (data.direction >= 202.5 && data.direction < 247.5) { txtdir = "SW"; }
    if (data.direction >= 247.5 && data.direction < 292.5) { txtdir =  "W"; }
    if (data.direction >= 292.5 && data.direction < 337.5) { txtdir = "NW"; }
    if (data.direction >= 337.5 && data.direction < 360.0) { txtdir =  "N"; }

    colors = setColors(data.id, data.direction, data.windspeed);

    if (data.windspeed < 1) {
      txtdir = "·";
      document.getElementById("compassarrow" + data.id).style.visibility = "hidden";
    } else {
      document.getElementById("compassarrow" + data.id).style.visibility = "visible";
    }

    document.getElementById("direction-txt" + data.id).innerHTML   = txtdir;
    document.getElementById("direction-txt" + data.id).style.color = colors.dirn;
    document.getElementById("windspeed"     + data.id).innerHTML   = (units == "m"? data.windspeed.toFixed(0) + "kph" : (data.windspeed * 0.621371).toFixed(0) + "mph");
    document.getElementById("windspeed"     + data.id).style.color = colors.spd;

    document.getElementById("compassarrow" + data.id).style.transform = "rotate(" + data.direction + "deg)";
  } else { // if (data.direction !== null)
    document.getElementById("direction-txt" + data.id).innerHTML   = "???";
    document.getElementById("direction-txt" + data.id).style.color = "red";
    document.getElementById("windspeed"     + data.id).innerHTML   = (units == "m"? "?kph" : "?mph");
    document.getElementById("windspeed"     + data.id).style.color = "red";

    document.getElementById("compassarrow" + data.id).style.visibility = "hidden";
  } // if (data.direction !== null) else

  document.getElementById("time" + data.id).innerHTML = pad(date.getHours(), 2) + ":" + pad(date.getMinutes(), 2) + ":" + pad(date.getSeconds(), 2);

  var clientsnum = document.getElementById("numClients");

  if (typeof(clientsnum) != "undefined" && clientsnum != null) {
    clientsnum.innerHTML = data.clients;
  }

  lastNum = data.num;
}


// Sets the warning colors for direction and wind strength for each station
function setColors(stn, dirn, spd) {
  var colors = {dirn:"gray", spd: "gray" };

  switch(stn) {
  case 1151595: // TigerLZ
    if (dirn >=   0.0 && dirn <  22.5) { colors.dirn = "green";  } // N
    if (dirn >=  22.5 && dirn <  67.5) { colors.dirn = "orange"; } // NE
    if (dirn >=  67.5 && dirn < 112.5) { colors.dirn = "red";    } // E
    if (dirn >= 112.5 && dirn < 157.5) { colors.dirn = "orange"; } // SE
    if (dirn >= 157.5 && dirn < 202.5) { colors.dirn = "green";  } // S
    if (dirn >= 202.5 && dirn < 247.5) { colors.dirn = "orange"; } // SW
    if (dirn >= 247.5 && dirn < 292.5) { colors.dirn = "red";    } // W
    if (dirn >= 292.5 && dirn < 337.5) { colors.dirn = "orange"; } // NW
    if (dirn >= 337.5 && dirn < 360.0) { colors.dirn = "green";  } // N

    if (spd >= 20) { colors.spd = "red";    }
    if (spd <  20) { colors.spd = "orange"; }
    if (spd <  10) { colors.spd = "green";  }

    break;

  case 14018695: // NorthLaunch
    if (dirn >=   0.0 && dirn <  22.5) { colors.dirn = "orange"; } // N
    if (dirn >=  22.5 && dirn <  67.5) { colors.dirn = "red";    } // NE
    if (dirn >=  67.5 && dirn < 112.5) { colors.dirn = "red";    } // E
    if (dirn >= 112.5 && dirn < 157.5) { colors.dirn = "red"; } // SE
    if (dirn >= 157.5 && dirn < 202.5) { colors.dirn = "red";  } // S
    if (dirn >= 202.5 && dirn < 247.5) { colors.dirn = "red";  } // SW
    if (dirn >= 247.5 && dirn < 292.5) { colors.dirn = "orange"; } // W
    if (dirn >= 292.5 && dirn < 337.5) { colors.dirn = "green";  } // NW
    if (dirn >= 337.5 && dirn < 360.0) { colors.dirn = "green";  } // N
    
    if (spd >= 20) { colors.spd = "red";    }
    if (spd <  20) { colors.spd = "orange"; }
    if (spd <  10) { colors.spd = "green";  }

    break;

  case 199866: // SouthLaunch
    if (dirn >=   0.0 && dirn <  22.5) { colors.dirn = "red"; }    // N
    if (dirn >=  22.5 && dirn <  67.5) { colors.dirn = "red";    } // NE
    if (dirn >=  67.5 && dirn < 112.5) { colors.dirn = "red";    } // E
    if (dirn >= 112.5 && dirn < 157.5) { colors.dirn = "orange"; } // SE
    if (dirn >= 157.5 && dirn < 202.5) { colors.dirn = "green";  } // S
    if (dirn >= 202.5 && dirn < 247.5) { colors.dirn = "green";  } // SW
    if (dirn >= 247.5 && dirn < 292.5) { colors.dirn = "orange"; } // W
    if (dirn >= 292.5 && dirn < 337.5) { colors.dirn = "red";  }   // NW
    if (dirn >= 337.5 && dirn < 360.0) { colors.dirn = "red";  }   // N

    if (spd >= 20) { colors.spd = "red";    }
    if (spd <  20) { colors.spd = "orange"; }
    if (spd <  10) { colors.spd = "green";  }

    break;
  }

  if (spd < 1) { colors.dirn = "green"; colors.spd = "green"; }

  return colors;
}


// Add null data if a station has stopped sending
function noData(nodt) {
  var date = new Date();

  document.getElementById("humidity" + nodt.id).innerHTML            = "-%";
  document.getElementById("humidity" + nodt.id).style.color          = "gray";
  document.getElementById("temperature" + nodt.id).innerHTML         = (units == "m"? "-&deg;C" : "-&deg;F");
  document.getElementById("temperature" + nodt.id).style.color       = "gray";
  document.getElementById("compassarrow" + nodt.id).style.visibility = "hidden";
  document.getElementById("direction-txt" + nodt.id).innerHTML       = "off";
  document.getElementById("direction-txt" + nodt.id).style.color     = "gray";
  document.getElementById("windspeed" + nodt.id).innerHTML           = (units == "m"? "-kph" : "-mph");
  document.getElementById("windspeed" + nodt.id).style.color         = "gray";
  document.getElementById("time" + nodt.id).innerHTML                = pad(date.getHours(), 2) + ":" + pad(date.getMinutes(), 2) + ":" + pad(date.getSeconds(), 2);

  var clientsnum = document.getElementById("numClients");

  if (typeof(clientsnum) != "undefined" && clientsnum != null) {
    clientsnum.innerHTML = nodt.clients;
  }
}


// Returns a left zero padded number string
function pad(num, size) {
  var s = "00000000" + num;
  return s.substr(s.length - size);
}


function changeUnits() {
  if (units == "i") {
    units = "m";
  } else {
    units = "i";
  }

  stationIds.forEach(function(id) {
    document.getElementById("units" + id).innerHTML = units;
  });
}


// Clicking on the station name opens the station chart page
function gotoChart() {
  if (this.id.substring(11) == "199866") {
    window.location.href = "https://tempestwx.com/station/71752/graph/199866/wind/2";
  } else {
    window.location.href = "wxstn/wx.html?id=" + this.id.substring(11);
  }
}

