# opsdcs API

simple and lightweight JSON API for DCS (DWE compatible)

## Installation

copy [opsdcs-api.lua](opsdcs-api.lua) into `Saved Games/DCS/Scripts/Hooks`

API is available once a simulation starts.

## Usage

### misc

GET http://127.0.0.1:31481/health - health check

GET http://127.0.0.1:31481/current-mission - returns mission data

POST http://127.0.0.1:31481/lua - executes lua

GET http://127.0.0.1:31481/player-unit - returns player unit

### dynamic static objects

GET http://127.0.0.1:31481/static-objects - returns created static objects

POST http://127.0.0.1:31481/static-objects - creates static objects

DELETE http://127.0.0.1:31481/static-objects - deletes static objects

DELETE http://127.0.0.1:31481/clear-all - deletes all static objects

### camera

GET http://127.0.0.1:31481/camera-position - gets camera position

POST http://127.0.0.1:31481/camera-position - sets camera position (smooth lerped)

### export

GET http://127.0.0.1:31481/export-world-objects - returns world objects

GET http://127.0.0.1:31481/export-self-data - returns self data

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

GET http://127.0.0.1:31481/db-theatres - returns installed theatres info

GET http://127.0.0.1:31481/db-terrains - returns beacons, radio and towns info from terrains

GET http://127.0.0.1:31481/coords - coordinate conversion
