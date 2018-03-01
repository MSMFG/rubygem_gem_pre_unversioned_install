class << $LOAD_PATH
  def merge!(other)
    replace(self | other)
  end
end

$LOAD_PATH.merge! [File.expand_path('../lib', __FILE__)]

Gem::Specification.new do |spec|
  raise 'RubyGems 2.0 or newer is required.' unless spec.respond_to?(:metadata)
  spec.name = 'gem_pre_unversioned_install'
  spec.version = '1.0.0'
  spec.authors = ['Andrew Smith']
  spec.email = ['andrew.smith at moneysupermarket.com']

  spec.summary = 'Add pre_unversioned_install hook to RubyGems'
  spec.description = 'Allows custom actions in delivery pipelines for RubyGem'\
                     ' installations that have no version specifications'
  spec.homepage = 'https://github.com/MSMFG/rubygem_gem_pre_unversioned_install'
  spec.license = 'Apache-2.0'
  spec.files = `git ls-files -z`.split("\x0")
end
