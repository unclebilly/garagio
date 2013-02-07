Garagio
===========================

This project is a web interface to open and close a garage door. 


I am using a [WiFly RN-XV](http://www.rovingnetworks.com/products/RN171XV) 
with a wire antenna for WiFi connectivity.  I'm following [a 
tutorial for a DIY garage door opener](http://www.dinnovative.com/?p=163).

Hopefully, I won't fry my garage door opener or my WiFly in the process!

One thing that tripped me up was that the original author never mentioned that 
you need to disable the "alternate function" of GPIO pins 4,5, and 6 for this project
(well, at least GPIO 4, which has the 24 mA necessary to drive the relay and the 
LED).  This disables the little LED lights on the WiFly board, which opens up the
pins for other functionality (such as powering a relay).  Since there are no more
LED's on the board, the power indicator LED external to the board is necessary.
```
set sys iofunc 0x07
```