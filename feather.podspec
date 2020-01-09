Pod::Spec.new do |spec|
  spec.name = "Feather"
  spec.version = "1.0.3"
  spec.summary = "A modern html based rich text editor for iOS and macOS (Catalyst or AppKit) written in Swift. You can use Quill or Froala."
  spec.homepage = "https://github.com/MadeByDouglas/feather"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Douglas Hewitt" => 'madebydouglas@gmail.com' }
  spec.social_media_url = "http://twitter.com/madebydouglas"

  spec.swift_version = '5.1'

  spec.ios.deployment_target  = '13.0'
  spec.osx.deployment_target  = '10.15'

  spec.requires_arc = true
  spec.source = { git: "https://github.com/MadeByDouglas/feather.git", tag: "#{spec.version}", submodules: true }
  
  spec.source_files = "Feather/Source/**/*.{h,swift}"

  spec.resources = 'Feather/Resources/**'

  spec.resource_bundles = {
    'Feather' => ['Feather/Resources/**']
  }

  spec.framework = 'SystemConfiguration'
  
end