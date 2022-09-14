# Bird Up — Tiger Mountain

> Tiger Mountain Paragliding Weather

## TODO
- [x] Fix NaN
- [x] Historical graph page
- [x] Use empty data point rather than discarding sample
- [x] Live cam
- [x] Forecasting data plan
- [x] Refresh button / pull to refresh
- [x] Use min/max and gust instead of pressure and humidity data
- [ ] Add fixed legend to the history table

## Overview

This is a cross-platform mobile application to display weather data provided by drw.selfip.com (David Wheeler), and weather forecasts provided by http://wxtofly.net (TJ Olney). 

## Station API

> wss://drw.selfip.com/wxstn/ws

### Stations

- North Launch: 14018695
- South Launch: 199866
- Tiger LZ: 1151595

## Messages

### Requests

**Station Name**
```text
stnm:<ID>
```

**Request Stream**
```text
stwx:<ID>
```

**Backfill**
```text
bkwx:<ID>:4hour
```

### Response

**Station Name**
```
stnm:<ID>,<NAME>
```

**No Data**
```
nodt,<MESSASGE>
```

**Data**
```
data:{
  "id": 14018695,                   // Station
  "num": 37324,                     // Packet #
  "ts": 1656856881000,              // Timestamp
  "temperature": 9.921532922014034, // Celcius  [-50, 50]
  "pressure": 1012.0289982032618,   // mBar     [850, 1100]
  "humidity": 100,                  // %        [0, 100]
  "windspeed": 2.275838700412476,   // KPH      [0, 100]
  "direction": 153.7139176223352,   // Degree   [0, 360]
  "voltage": 3.307,
  "clients": 13
}
```

**Blob**
```
# 32-bit floats

Field           Bytes       Units
-----------     ----------- -------------
Timestamp       [00-03]     Seconds
Temp            [04-07]     C
Temp Max        [08-11]     C
Temp Min        [12-15]     C
Pressure        [16-19]     mBar
Humidity        [20-23]     %
Windspeed       [24-27]     KPH
Windspeed Max   [28-31]     KPH
Wind Direction  [32-35]     Degrees
Voltage         [36-39]     Volts..
V Max           [40-43]
V Min           [44-47]
A?              [48-51]     Amperage?
AMax?           [52-55]
R?              [56-59]
EX?             [60-63]
ED?             [64-67]
ER?             [68-71]
```

## Forecast

> http://wxtofly.net/RASP/TIGER/FCST/?C=M;O=D

| Measurement            | URL |
|------------------------|-----|
| Surface Winds 2m       | |
| 10 Meter Winds         | |
| Tree Top Winds         | |
| 2nd Higher-level Winds | |
| BL Average Winds       | |
| BL Top Winds           | |
| BL Vertical Wind Shear | |
| THERMAL                | |
| B/S Ratio              | |
| Thermal Strength       | |
| Bouyancy/Shear Ratio   | |
| Max Soaring | |
| Max (1m/s) updraft heigh above MSL | |
| Max (1m/s) updraft height AGL | |
| MSL Height of Max WBL | |
| BL Depth | |
| Height of BL Top | |
| CLOUDS | |
| Percent of BL Clouds | |
| Mid-level Clouds | |
| High Clouds | |
| Cumulus Clouds Likelihood | |
| Overcast Development Possibilities | |
| Rain accumulation over previous hour | |


## Guide

Routing and DI are generated. This command starts the build watch.

```shell
flutter packages pub run build_runner watch
```

### State Management

Bloc pattern.

### Routing

AutoRoute. Each "page" in `pages/` builds a Scaffold and is registered in `routes.dart`.

```dart
@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: RootPage, initial: true),
    // ...
  ],
)

class Routes extends _$Routes {}
```
