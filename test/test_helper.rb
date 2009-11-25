base = File.expand_path("../", File.dirname(__FILE__))
$: << base << File.join(base, "test") << File.join(base, "lib")
require 'test/unit'
require 'shoulda'
require 'looking_glass'
require 'sample_objects'