# opsdcs API

simple and lightweight JSON API for DCS (DWE compatible)

## Installation

copy [opsdcs-api.lua](opsdcs-api.lua) into `Saved Games/DCS/Scripts/Hooks`

## Usage

### misc

GET http://127.0.0.1:31481/health - health check

GET http://127.0.0.1:31481/mission-data - returns mission data

POST http://127.0.0.1:31481/lua - executes lua

### static objects

GET http://127.0.0.1:31481/static-objects - returns created static objects

POST http://127.0.0.1:31481/static-objects - creates static objects

POST http://127.0.0.1:31481/delete-static-objects - deletes static objects

DELETE http://127.0.0.1:31481/clear-all - deletes all static objects

### camera

POST http://127.0.0.1:31481/set-camera-position - sets camera position
