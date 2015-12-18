Pod::Spec.new do |s|
    s.name = 'PushwooshZP'
    s.version = '0.1.0'
    s.license = 'MIT'
    s.summary = 'Wrapper for Pushwoosh Zeropush migration'
    s.authors = { 'Michael Loistl' => 'michael@aplo.co' }
    s.source = { :git => 'https://github.com/michaelloistl/PushwooshZP.git', :tag => s.version }

    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.9'
    s.watchos.deployment_target = '2.0'

    s.source_files = 'PushwooshZP/*.{swift}'

    s.requires_arc = true

    s.dependency 'Alamofire', '~> 3.1'
end