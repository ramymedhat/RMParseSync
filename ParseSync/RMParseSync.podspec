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
  spec.frameworks = 'Parse', 'CoreData'
  spec.prefix_header_contents = '#import <CoreData/CoreData.h>', '#import <Foundation/Foundation.h>', '#import <Parse/Parse.h>'
  s.requires_arc = true
end