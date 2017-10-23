platform :ios, '7.0'
#inhibit_all_warnings!
#source 'https://github.com/CocoaPods/Specs.git'

target ‘pairearch_WLY’ do

pod 'AFNetworking'
pod 'MJRefresh'
pod 'MBProgressHUD'
pod 'UMengAnalytics-NO-IDFA'
pod 'IQKeyboardManager'


pod 'DYLocationConverter', '~> 0.0.4'
pod 'MBProgressHUD+BWMExtension', '~> 1.0.1'
pod 'Masonry', '~> 1.0.2'
pod 'TZImagePickerController', '~> 1.7.8'
pod 'SAMKeychain', '~> 1.5.2'
pod 'JPush', '~> 3.0.2'

#pod 'JZLocationConverter', '~> 1.0.0'
#pod 'SDWebImage'
#pod 'BaiduMobStat'
#pod 'XHVersion', '~> 1.0.1'

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-[工程名]/Pods-[工程名]-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }

end
