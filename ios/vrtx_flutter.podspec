Pod::Spec.new do |s|
  s.name             = 'vrtx_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Flutter wrapper for the Vrtx fintech SDK.'
  s.description      = 'Onboarding, wallet, and card flows via Vrtx — cross-platform Flutter plugin.'
  s.homepage         = 'https://github.com/vrtx-fintech/vrtx-flutter'
  s.license          = { :type => 'Apache-2.0' }
  s.author           = { 'Vrtx' => 'support@vrtx.sa' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'

  s.platform         = :ios, '15.6'
  s.swift_version    = '5.9'

  # The VRTX.xcframework is intentionally not committed (binary, not a source
  # artefact). `scripts/fetch_vrtx_ios.sh` downloads it into ios/Frameworks/
  # before `pod install` runs (CI does this in `.github/workflows/ios.yml`;
  # local developers run it once after cloning).
  # See: https://github.com/vrtx-fintech/vrtx-ios/releases
  s.vendored_frameworks = 'Frameworks/VRTX.xcframework'
  s.static_framework = true

  s.dependency 'Flutter'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
  }
end
