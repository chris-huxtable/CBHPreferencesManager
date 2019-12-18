Pod::Spec.new do |spec|

  spec.name                   = 'CBHPreferencesManager'
  spec.version                = '1.0.0'
  spec.module_name            = 'CBHPreferencesManager'

  spec.summary                = 'An easy-to-use preferences manager.'
  spec.homepage               = 'https://github.com/chris-huxtable/CBHPreferencesManager'

  spec.license                = { :type => 'ISC', :file => 'LICENSE' }

  spec.author                 = { 'Chris Huxtable' => 'chris@huxtable.ca' }
  spec.social_media_url       = 'https://twitter.com/@Chris_Huxtable'

  spec.osx.deployment_target  = '10.11'

  spec.source                 = { :git => 'https://github.com/chris-huxtable/CBHPreferencesManager.git', :tag => "v#{spec.version}" }

  spec.requires_arc           = true

  spec.public_header_files    = 'CBHPreferencesManager/**/*.h'
  spec.private_header_files   = 'CBHPreferencesManager/**/_*.h'
  spec.source_files           = 'CBHPreferencesManager/**/*.{h,m}'

end
