$:.unshift(File.dirname(__FILE__))

begin
  ''.blank?
rescue NoMethodError
  require 'graticule/blank'
end

require 'graticule/version'
require 'graticule/location'
require 'graticule/geocoder'
require 'graticule/geocoder/base'
require 'graticule/geocoder/bogus'
require 'graticule/geocoder/rest'
require 'graticule/geocoder/google'
require 'graticule/geocoder/host_ip'
require 'graticule/geocoder/map_quest'
require 'graticule/geocoder/multi'
require 'graticule/geocoder/yahoo'
require 'graticule/geocoder/geocoder_ca'
require 'graticule/geocoder/geocoder_us'
require 'graticule/geocoder/local_search_maps'
require 'graticule/geocoder/meta_carta'
require 'graticule/geocoder/postcode_anywhere'
require 'graticule/geocoder/multimap'
require 'graticule/distance'
require 'graticule/distance/haversine'
require 'graticule/distance/spherical'
require 'graticule/distance/vincenty'
require 'graticule/active_support_methods'
