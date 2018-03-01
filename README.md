# Gem.pre_unversioned_install

This gem provides a RubyGems plugin that adds a hook method called prior to installation of any future RubyGem that uses simply latest version rather than some formal version pinning.

It is intended for use in large continuous delivery codebases to highlight vulnerabilites to external change and may be leveraged by creating an additional plugin to register your own custom hooks via the method and perform such actions as notifying your DevOps team.
## Example use

Within your own rubygems_plugin.rb...
```
require 'rubygems'
# Ensures dependency order
require 'gem_pre_unversioned_install'

Gem.pre_unversioned_install do |name, version|
  # Do anything you want with name and the version that RubyGems automatically determined
end
```

An example plugin can be found in the examples folder which one can use via the -I Ruby option.

From the gem folder one can test with
```
C02T6183G8WL:gem_pre_unversioned_install andrew.smith$ RUBYOPT=-Iexamples gem install net-ssh msmg_public:0.2.0
UNVERSIONED GEM: net-ssh request
       SELECTED: 4.2.0
Successfully installed net-ssh-4.2.0
Parsing documentation for net-ssh-4.2.0
Done installing documentation for net-ssh after 1 seconds
Successfully installed msmg_public-0.2.0
Parsing documentation for msmg_public-0.2.0
Done installing documentation for msmg_public after 0 seconds
2 gems installed
C02T6183G8WL:gem_pre_unversioned_install andrew.smith$ 
```

Since the mechanism utilises the Gem::Dependency class to detect unversioned gem installs it should be compatible with all forms of version specification including --version flag and other tools such as bundler.
