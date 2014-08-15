Pod::Spec.new do |s|
  s.name         = 'RMParseSync'
  s.version      = '0.3.1'
  s.summary      = 'Parse Core Data Sync'
  s.author = {
    'Ramy Medhat' => 'ramymedhat@gmail.com'
  }
  s.source = {
    :git => 'https://github.com/ramymedhat/RMParseSync.git',
    :tag => '0.1.0'
  }
  s.source_files = 'ParseSync/ParseSync/*.{h,m}'
  spec.frameworks = 'Parse'
  s.requires_arc = true
end