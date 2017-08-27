Pod::Spec.new do |spec|
  spec.name         = 'TableFlip'
  spec.version      = '1.0.1'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage     = 'https://github.com/mergesort/TableFlip'
  spec.authors      =  { 'Joe Fabisevich' => 'github@fabisevi.ch' }
  spec.summary      = 'A simpler way to do cool UITableView animations! (╯°□°）╯︵ ┻━┻'
  spec.source       =   { :git => 'https://github.com/mergesort/TableFlip.git', :tag => "#{spec.version}" }
  spec.source_files = 'src/*.swift'
  spec.framework    = 'Foundation'
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/mergesort'
  spec.ios.deployment_target = '8.0'

end
