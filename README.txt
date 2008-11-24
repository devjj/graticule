= Graticule

NOTE: This fork of graticule contains a copy of the ActiveSupport methods that were used by the original plugin, modified to work with the new structure.  This removes the ActiveSupport dependency, making the library freestanding.

Graticule is a geocoding API for looking up address coordinates.  It supports many popular APIs, including Yahoo, Google, Geocoder.ca, Geocoder.us, PostcodeAnywhere and MetaCarta.

= Usage

  require 'rubygems'
  require 'graticule'
  geocoder = Graticule.service(:google).new "api_key"
  location = geocoder.locate "61 East 9th Street, Holland, MI"

= Distance Calculation

Graticule includes 3 different distance formulas, Spherical (simplest but least accurate), Vincenty (most accurate and most complicated), and Haversine (somewhere inbetween).

  geocoder.locate("Holland, MI").distance_to(geocoder.locate("Chicago, IL"))
  #=> 101.997458788177
  
= Command Line

Graticule includes a command line interface (CLI).

  $ geocode -s yahoo -a yahookey Washington, DC
  Washington, DC US
  latitude: 38.895222, longitude: -77.036758

= Source

The original source code for Graticule is available at http://github.com/collectiveidea/graticule. Patches and bug reports are welcome at http://collectiveidea.lighthouseapp.com/projects/20262-graticule

The source for this modified version of graticule is available at http://github.com/devjj/graticule/tree/master
