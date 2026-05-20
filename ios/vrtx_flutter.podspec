Pod::Spec.new do |s|
  s.name             = 'vrtx_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Flutter wrapper for the Vrtx fintech SDK.'
  s.description      = 'Onboarding, wallet, and card flows via Vrtx — cross-platform Flutter plugin.'
  s.homepage         = 'https://github.com/vrtx-fintech'
  s.license          = { :type => 'Apache-2.0' }
  s.author           = { 'Vrtx' => 'support@vrtx.sa' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'

  s.platform         = :ios, '15.6'
  s.swift_version    = '5.9'

  # Vrtx iOS SDK via Swift Package Manager bridge
  s.dependency 'VRTX', '~> 0.0.15'

  s.dependency 'Flutter'
end
