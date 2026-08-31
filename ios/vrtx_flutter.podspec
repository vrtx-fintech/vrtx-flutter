Pod::Spec.new do |s|
  s.name             = 'vrtx_flutter'
  s.version          = '0.1.3'
  s.summary          = 'Flutter wrapper for the Vrtx fintech SDK.'
  s.description      = 'Onboarding, wallet, and card flows via Vrtx — cross-platform Flutter plugin.'
  s.homepage         = 'https://github.com/vrtx-fintech/vrtx-flutter'
  s.license          = { :type => 'Apache-2.0' }
  s.author           = { 'Vrtx' => 'support@vrtx.sa' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'

  s.platform         = :ios, '15.6'
  s.swift_version    = '5.9'

  s.static_framework = true

  s.dependency 'Flutter'

  # The Vrtx iOS SDK ships as a binary XCFramework published to CocoaPods
  # trunk (https://github.com/vrtx-fintech/vrtx-ios). CocoaPods downloads and
  # embeds it automatically, mirroring how Android pulls `vrtx-android` from
  # Maven Central. Keep this version aligned with the VRTX pod release.
  s.dependency 'VRTX', '0.1.10'
  # VRTX 0.1.10 imports DeviceKit from its public Swift interface. Declare it
  # explicitly so CocoaPods links it for Flutter consumers. Pinned to the same
  # exact version the vrtx-ios README pins for SwiftPM consumers — the
  # xcframework is compiled against this module, so a minor drift can break
  # the build with a Swift module-compatibility error.
  s.dependency 'DeviceKit', '5.7.0'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
  }
end
