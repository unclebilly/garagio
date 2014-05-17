Garagio
===========================

This project is a web interface to open and close a garage door. 

I am using a [Spark Core](http://spark.io) for WiFi connectivity.  I followed [a 
tutorial for a DIY garage door opener](http://www.dinnovative.com/?p=163), but 
ended up doing things a tad bit differently - I use a transistor to handle the switching load for the 
relay, and I use a Spark Core instead of a WiFly RNXV. 

__NOTE__ In the first version of Garagio, I _did_ use a [WiFly RN-XV](http://www.rovingnetworks.com/products/RN171XV) for 
network connectivity. See tag v1.0.0 for the WiFly version.  

Installation
============
Git clone this project. 
Install gems with bundler: 
    
    $ bundle install

Garagio Setup
=============
* Copy `config/config.rb.example` to `/config/config.rb`
* Create an auth token and a door access code. 

Running the app
===============
For demonstration purposes, you can run `rackup`: 
    
    $ rackup

Now visit `localhost:9292/?auth_token=YOUR_AUTH_TOKEN` and you should see the door opener page. Here is a screenshot of the garage door app, running on an Android phone. The user 
is expected to enter the code into the text field and then tap the garage
door opener icon. 

![Garagio screenshot](https://raw.github.com/unclebilly/garagio/master/doc/pics/garagio_screenshot.png "garagio screenshot")