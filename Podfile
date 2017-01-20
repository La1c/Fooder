use_frameworks!

target 'Fooder' do
pod 'SwiftyJSON'
pod 'Alamofire', '~> 4.0'
pod 'RealmSwift'
pod 'DZNEmptyDataSet'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

plugin 'cocoapods-keys', {
	:keys => [
	"FoodAPIKey"
  ]}
end
