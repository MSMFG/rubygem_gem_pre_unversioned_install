# Gem.pre_unversioned_install hook
require 'rubygems'

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

  # Reader only
  def self._unversioned_hooks
    # dup to protect collection integrity
    @_unversioned_hooks.dup
  end

  # Monkey patch to capture gem name if latest_version? true
  class Dependency
    alias _latest_version? latest_version?

    # Stash any unversioned dependencies encountered
    def latest_version?
      if (res = _latest_version?)
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
  # pre_install hooks can cause gem install to abort if they return false
  # so we allow our plugins to do the same and trigger this behaviour
  rval = nil
  Gem._unversioned_hooks.each do |hook|
    break if false == (rval = hook.call(spec.name, spec.version))
  end
  rval
end
