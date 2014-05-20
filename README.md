Garagio
===========================

Garagio is a web interface to open and close a garage door.  This project assumes you are using a [Spark Core](http://spark.io) for WiFi connectivity.  

__NOTE__ In the first version of Garagio, I used a [WiFly RN-XV](http://www.rovingnetworks.com/products/RN171XV) for network connectivity. See tag v1.0.0 for the WiFly version.  

Installation
============
Git clone this project. 
Install gems with bundler: 
    
    $ bundle install

Garagio Setup
=============
* Copy `config/config.yml.example` to `/config/config.yml`
* Fill in your Spark Core auth token and device id, and make up a door access code. 
* All variables in config.yml can alternatively be specified as environment variables (capitalized). For example, if you wish, you can omit PASSCODE, AUTH_TOKEN, and DEVICE_ID from config.yml and specify them when starting up: 

    AUTH_TOKEN=foo DEVICE_ID=bar PASSCODE=4444 rackup

Running the app
===============
Garagio is a Rack application. You can use any Rack-compatible server to run it.  For development purposes, you can use `rackup`:
    
    $ rackup

Now visit `localhost:9292` and you should see the door opener page. Here is a screenshot of the garage door app, running on an Android phone. The user 
is expected to enter the code into the text field and then tap the garage
door opener icon. 

![Garagio screenshot](https://raw.github.com/unclebilly/garagio/master/doc/pics/garagio_screenshot.png "garagio screenshot")