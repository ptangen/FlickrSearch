# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'flickr-Search' do

	use_frameworks!

  # Pods for flickr-Search
	pod 'SDWebImage'
	pod 'SwiftyJSON', '~> 3.1'

	target 'flickr-SearchTests' do
		inherit! :search_paths
		pod 'KIF'
		
	end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
