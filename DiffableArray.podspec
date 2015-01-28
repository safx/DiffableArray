Pod::Spec.new do |s|
  s.name         = "DiffableArray"
  s.version      = "0.1.1"
  s.summary      = "an array notifying the changing automatically"
  s.homepage     = "https://github.com/safx/DiffableArray"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "MATSUMOTO Yuji" => "safxdev@gmail.com" }
  s.source       = { :git => "https://github.com/safx/DiffableArray.git", :tag => s.version }
  s.source_files = "DiffableArray.swift"
  s.framework    = 'Foundation'
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.requires_arc = true
end
