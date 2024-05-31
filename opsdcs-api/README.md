# opsdcs API

simple and lightweight JSON API for DCS (DWE compatible)

## Installation

copy [opsdcs-api.lua](Hooks/opsdcs-api.lua) into `Saved Games/DCS/Scripts/Hooks`

## Usage

### misc

GET http://127.0.0.1:31481/health - health check

GET http://127.0.0.1:31481/mission-data - returns mission data

POST http://127.0.0.1:31481/lua - executes lua

### dynamic static objects

GET http://127.0.0.1:31481/static-objects - returns created static objects

POST http://127.0.0.1:31481/static-objects - creates static objects

POST http://127.0.0.1:31481/delete-static-objects - deletes static objects

DELETE http://127.0.0.1:31481/clear-all - deletes all static objects

### camera

POST http://127.0.0.1:31481/set-camera-position - sets camera position

### export

GET http://127.0.0.1:31481/export-world-objects - returns world objects

### db

GET http://127.0.0.1:31481/db-countries - returns countries

GET http://127.0.0.1:31481/db-countries-by-name - returns countries by name

GET http://127.0.0.1:31481/db-units - returns units

GET http://127.0.0.1:31481/db-weapons - returns weapons

GET http://127.0.0.1:31481/db-callnames - returns callnames

GET http://127.0.0.1:31481/db-sensors - returns sensors

GET http://127.0.0.1:31481/db-pods - returns pods

GET http://127.0.0.1:31481/db-farp-objects - returns farp objects

GET http://127.0.0.1:31481/db-objects - returns objects

GET http://127.0.0.1:31481/db-years - returns years info

GET http://127.0.0.1:31481/db-years-launchers - returns years/launchers info

GET http://127.0.0.1:31481/db-theatres - returns theatres info

GET http://127.0.0.1:31481/db-beacons-from-lua?path=beacon.lua - returns lua data from beacon file

GET http://127.0.0.1:31481/db-radio-from-lua?path=radio.lua - returns lua data from radio file

GET http://127.0.0.1:31481/db-nodes-from-lua?path=nodes.lua - returns lua data from nodes file

GET http://127.0.0.1:31481/image?path=foo/bar.png - returns image from DCS files
