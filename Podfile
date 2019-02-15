# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Monkey' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    post_install do |installer|
        installer.pods_project.build_configurations.each do |config|
            config.build_settings.delete('CODE_SIGNING_ALLOWED')
            config.build_settings.delete('CODE_SIGNING_REQUIRED')
        end
    end
    # Pods for Monkey
    pod 'Braintree/PayPal'
    pod 'BraintreeDropIn'
    pod 'SideMenu'
    pod 'HCSStarRatingView', '~> 1.5'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'EZSwiftExtensions'
    pod 'Material'
    pod 'IBAnimatable'
    pod 'IQKeyboardManagerSwift'
    pod 'RMMapper'
    pod 'SDWebImage'
    pod 'ObjectMapper', '~> 3.3.0'
    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
    pod 'FBSDKShareKit'
    pod 'MXSegmentedPager'
    pod 'NVActivityIndicatorView'
    pod 'CropViewController'
    pod 'GoogleSignIn'
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'Stripe'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    
    target 'MonkeyTests' do
        inherit! :search_paths
        # Pods for testing
    end
    
    target 'MonkeyUITests' do
        inherit! :search_paths
        # Pods for testing
    end
    
end
