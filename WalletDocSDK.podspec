Pod::Spec.new do |s|

  s.name                = "WalletDocSDK"
  s.version             = "1.0.0"
  s.summary             = "A WalletDocSDK used for payment gateway."
  s.description         = "Testing fjdh fdjfdghj fdjhfd jdfjhf jfhd dffd."
  s.homepage            = "http://walletdoc.com"
  s.license             = "MIT"
  s.author              = "Kunal parekh"
  s.platform            = :ios, "13.2"
  s.source              = { :git => "https://github.com/KunalDev/WDSDK.git", :tag => "#{s.version}" }
  s.source_files  = "WalletDocSDK/**/*.{h,m,swift}"
  s.resources = "WalletDocSDK/**/*.{xcassets,storyboard,xib}"
  s.exclude_files = "Classes/Exclude"
  s.swift_version       = "5.1"

end
