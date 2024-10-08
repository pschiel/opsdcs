# opsdcs API

simple and lightweight JSON API for DCS

## Installation

copy [opsdcs-api.lua](opsdcs-api.lua) into `Saved Games/DCS/Scripts/Hooks`

API is available once a simulation starts (main menu).
There is NO sanitizing required.

## Usage

### misc

GET http://127.0.0.1:31481/health - health check

GET http://127.0.0.1:31481/current-mission - returns mission data

POST http://127.0.0.1:31481/lua - executes lua in any environment

GET http://127.0.0.1:31481/player-unit - returns player unit

GET http://127.0.0.1:31481/coords - coordinate conversion

### dynamic static objects

GET http://127.0.0.1:31481/static-objects - returns created static objects

POST http://127.0.0.1:31481/static-objects - creates static objects

DELETE http://127.0.0.1:31481/static-objects - deletes static objects

DELETE http://127.0.0.1:31481/static-objects/all - deletes all static objects

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

GET http://127.0.0.1:31481/db-launcher - returns launcher

GET http://127.0.0.1:31481/db-pods - returns pods

GET http://127.0.0.1:31481/db-bombs - returns bombs

GET http://127.0.0.1:31481/db-guns - returns guns

GET http://127.0.0.1:31481/db-torpedoes - returns torpedoes

GET http://127.0.0.1:31481/db-rockets - returns rockets

GET http://127.0.0.1:31481/db-pylons - returns pylons

GET http://127.0.0.1:31481/db-plugins - returns plugins

GET http://127.0.0.1:31481/db-gtt - returns GT_t templates

GET http://127.0.0.1:31481/db-years - returns years info

GET http://127.0.0.1:31481/db-years-launchers - returns years/launchers info

GET http://127.0.0.1:31481/db-farp-objects - returns farp objects

GET http://127.0.0.1:31481/db-objects - returns objects

GET http://127.0.0.1:31481/db-theatres - returns installed theatres info

GET http://127.0.0.1:31481/db-terrains - returns beacons, radio and towns info from terrains
