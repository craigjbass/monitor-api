require 'require_all'

Dir.glob(__dir__ + '/**/namespaces.rb').each do |f|
  require_relative f
end

require_rel '.'
$LOAD_PATH.unshift File.expand_path('.', __FILE__)
