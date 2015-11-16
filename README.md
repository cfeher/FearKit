#FearKit 
![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat) ![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)
![Status](https://img.shields.io/badge/status-prerelease-orange.svg?style=flat)

A framework with useful iOS stuff I found myself always having to re-implement on different projects

## Requirements
- iOS 9.0+

## Samples
###FKSegmentedControl

```swift
let leftTab = FKSegmentedControlSegment(backgroundView: TabView(frame: CGRectZero))
let rightTab = FKSegmentedControlSegment(backgroundView: TabView(frame: CGRectZero))

leftTab.externalNotifier = { segment, selected in
  //do something
}
rightTab.externalNotifier = { segment, selected in
  //do something
}

let tabSegmentedControl = FKSegmentedControl(
                                frame: CGRectZero, 
                                segments: [leftTab, rightTab])
                                
self.view.addSubview(tabSegmentedControl)
```

##Installation
### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate FearKit into your Xcode project using Carthage, specify it in your `Cartfile`:

1. Create a `Cartfile` that lists the frameworks you’d like to use in your project.
1. Run `carthage update`. This will fetch dependencies into a `Carthage/Checkouts` folder, then build each one.
1. On your application targets’ “General” settings tab, in the “Linked Frameworks and Libraries” section, drag and drop each framework you want to use from the `Carthage/Build` folder on disk.
1. On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following contents:

  ```sh
  /usr/local/bin/carthage copy-frameworks
  ```

  and add the paths to the frameworks you want to use under “Input Files”, e.g.:

  ```
  $(SRCROOT)/Carthage/Build/iOS/FearKit.framework
  ```

  This script works around an [App Store submission bug](http://www.openradar.me/radar?id=6409498411401216) triggered by universal binaries.
  
  ####Example Cartfile
  ```
  github "Alamofire/Alamofire" >= 1.2
  github "cfeher/FearKit"
  ```
