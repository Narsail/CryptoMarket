# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared
    pod 'RxSwift', "~> 4.0.0"
    pod "RxCocoa"
    pod "SwiftLint"
    pod 'SteviaLayout', "~> 4.0"
    pod 'IGListKit', '~> 3.0'
    pod "PromiseKit", "~> 4.4", subspecs: ['CorePromise', 'CoreLocation']
    pod 'DefaultsKit'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Siesta', :path => "~/Developer/Github/siesta/", subspecs: ['Core', 'UI']
    pod 'SwiftDate'
end

target 'CryptoMarket' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CryptoMarket
  shared
  
  pod 'Siren'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git', :branch => 'wip/swift4'
  pod 'Charts'
  pod 'ReachabilitySwift'
  
  target 'CryptoMarketUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'iOS Today Widget' do
    use_frameworks!
    
    shared
end
