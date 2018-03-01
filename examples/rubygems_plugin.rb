# Example rubygems_plugin.rb utilising Gem.pre_unversioned_install
require 'rubygems'
require 'rubygems/user_interaction'
# Ensures dependency order
require 'gem_pre_unversioned_install'

Gem.pre_unversioned_install do |name, version|
  ui = Gem::DefaultUserInteraction.ui
  ui.say "UNVERSIONED GEM: #{name} request"
  ui.say "       SELECTED: #{version}"
  # Return false explicitly to cause abort
  true
end
