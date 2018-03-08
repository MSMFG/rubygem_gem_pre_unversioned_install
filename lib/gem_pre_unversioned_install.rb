# Gem.pre_unversioned_install hook
require 'rubygems'
require 'rubygems/dependency'

# Extend Gem module
module Gem
  # Module instance variable
  @_unversioned_gems  = []
  @_unversioned_hooks = []

  # Add unversioned name
  def self.unversioned(name)
    @_unversioned_gems |= [name]
  end

  # Check unversioned names
  def self.unversioned?(name)
    @_unversioned_gems.include?(name)
  end

  # Method to register our new hook type
  def self.pre_unversioned_install(&hook)
    @_unversioned_hooks |= [hook]
  end

  # Dispatch unversioned hooks
  def self.fire_unversioned_hooks(name, version)
    rval = nil
    # pre_install hooks can cause gem install to abort if they return false
    # so we allow our plugins to do the same and trigger this behaviour
    @_unversioned_hooks.each do |hook|
      break if (rval = hook.call(name, version)) == false
    end
    rval
  end

  # Monkey patch through subclassing
  class Dependency < remove_const(:Dependency)

    # Newer RubyGems use >=0 as a default requirement
    def initialize(_name, *requirements)
      super
      return unless requirements.find do |req|
        req.is_a?(Requirement) && req.none?
      end
      Gem.unversioned(@name)
    end

    # For older RubyGems versions
    def latest_version?
      if (res = super)
        Gem.unversioned(@name)
      end
      res
    end
  end
end

# To fire the pre_unversioned_install hooks
Gem.pre_install do |installer|
  spec = installer.spec
  next unless Gem.unversioned?(spec.name)
  Gem.fire_unversioned_hooks(spec.name, spec.version)
end
