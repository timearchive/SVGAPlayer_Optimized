#!/usr/bin/env ruby

# OptSVGAPlayer Xcode Target Setup Script
# This script automates the creation of the OptSVGAPlayer framework target

require 'xcodeproj'

project_path = 'Demo/Demo.xcodeproj'
project = Xcodeproj::Project.open(project_path)

puts "📦 Setting up OptSVGAPlayer framework target..."

# Create new framework target
target = project.new_target(:framework, 'OptSVGAPlayer', :ios, '12.0')

puts "✅ Created framework target: OptSVGAPlayer"

# Configure build settings
target.build_configurations.each do |config|
  config.build_settings['PRODUCT_NAME'] = 'OptSVGAPlayer'
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.svga.OptSVGAPlayer'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['DEFINES_MODULE'] = 'YES'
  config.build_settings['SKIP_INSTALL'] = 'NO'
  config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
  config.build_settings['INFOPLIST_FILE'] = 'OptSVGAPlayer/Info.plist'
  config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = config.name == 'Debug' ? '-Onone' : '-O'
end

puts "✅ Configured build settings"

# Add source files
source_files = [
  '../SVGAPlayer_Optimized/SVGARePlayer.h',
  '../SVGAPlayer_Optimized/SVGARePlayer.m',
  '../SVGAPlayer_Optimized/SVGAExPlayer.swift',
  '../SVGAPlayer_Optimized/SVGAVideoEntity+Extension.h',
  '../SVGAPlayer_Optimized/SVGAVideoEntity+Extension.m'
]

source_files.each do |file_path|
  file_ref = project.main_group.new_reference(file_path)
  target.add_file_references([file_ref])
  puts "  Added: #{File.basename(file_path)}"
end

# Add umbrella header
umbrella_header = project.main_group.new_reference('OptSVGAPlayer/OptSVGAPlayer.h')
target.add_file_references([umbrella_header])
puts "  Added: OptSVGAPlayer.h (umbrella header)"

# Configure headers phase
headers_build_phase = target.headers_build_phase
public_headers = [
  'SVGARePlayer.h',
  'SVGAVideoEntity+Extension.h',
  'OptSVGAPlayer.h'
]

headers_build_phase.files.each do |file|
  header_name = file.file_ref.path.split('/').last
  if public_headers.include?(header_name)
    file.settings = { 'ATTRIBUTES' => ['Public'] }
    puts "  Set #{header_name} as Public"
  end
end

puts "✅ Configured headers"

# Save project
project.save

puts "\n🎉 OptSVGAPlayer target setup complete!"
puts "\nNext steps:"
puts "1. cd Demo && pod install"
puts "2. Open Demo.xcworkspace in Xcode"
puts "3. Link Pods frameworks to OptSVGAPlayer target"
puts "4. Run ./Scripts/build_xcframework.sh"
