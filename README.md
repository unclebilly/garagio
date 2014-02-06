Garagio
===========================

This project is a web interface to open and close a garage door. 

I am using a [WiFly RN-XV](http://www.rovingnetworks.com/products/RN171XV) 
with a wire antenna for WiFi connectivity.  I followed [a 
tutorial for a DIY garage door opener](http://www.dinnovative.com/?p=163), but 
ended up doing things a tad bit differently - I used a transistor to handle the switching load for the 
relay (instead of switching it directly from the WiFly).  

Installation
============
Git clone this project. 
Install gems with bundler: 
    
    $ bundle install

WiFly Setup
===========
Before you can do anything, you have to connect your WiFly to your wireless network.  
* Turn off the WiFly.
* Set ad-hoc pin to high.
* Turn on the WiFly.
* Connect a wireless client to the WiFly AP.  Run the following commands.  See the manual if you are not using WPA2.

Run the following commands from your favorite terminal: 

    telnet 169.254.1.1 2000 # firmware versions ~< 2.3
    telnet 1.2.3.4 2000     # firmware versions ~> 4
    $$$
    set wlan auth 4         # wpa2/aes
    set wlan ssid [SSID]
    set wlan passphrase [PASSWORD]
    save

* Turn off the WiFly.
* Set the ad-hoc pin low.
* Turn on the WiFly.

First time setup only: connect again, and set the mask on these IO pins so that you can use them: 
    
    $$$
    set sys iofunc 0x7 
    save

Garagio Setup
=============
* Copy `config/config.rb.example` to `/config/config.rb`
* Change the IP address and port to your WiFly.  The port should be 2000 unless you changed it.
* Create an auth token and a door access code. 

Running the app
===============
For demonstration purposes, you can run `rackup`: 
    
    $ rackup

Now visit `localhost:9292/?auth_token=YOUR_AUTH_TOKEN` and you should see the door opener page. Here is a screenshot of the garage door app, running on an Android phone. The user 
is expected to enter the code into the text field and then tap the garage
door opener icon. 

![Garagio screenshot](https://raw.github.com/unclebilly/garagio/master/doc/pics/garagio_screenshot.png "garagio screenshot")