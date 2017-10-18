# helloworld-ios-swift

[![circle-ci](https://img.shields.io/circleci/project/github/feedhenry-templates/helloworld-ios-swift/master.svg)](https://circleci.com/gh/feedhenry-templates/helloworld-ios-swift)


> Obj-C version is available [here](https://github.com/feedhenry-templates/helloworld-ios).

Author: Corinne Krych, Daniel Passos   
Level: Intermediate   
Technologies: Swift 4, iOS, RHMAP, CocoaPods.   
Summary: A demonstration of how to get started with remote cloud call in RHMAP.   
Community Project: [Feed Henry](http://feedhenry.org)   
Target Product: RHMAP   
Product Versions: RHMAP 3.7.0+   
Source: https://github.com/feedhenry-templates/helloworld-ios-swift   
Prerequisites: fh-ios-swift-sdk: 6+, Xcode: 9+, iOS SDK: iOS 9+, CocoaPods 1.3.0+

## What is it?

Simple native iOS app to test your remote cloud connection in RHMAP. Its server side companion app: [HelloWorld Cloud App](https://github.com/feedhenry-templates/helloworld-cloud). This template app demos how to intialize a cloud call and make calls to cloud endpoints. The app uses [fh-ios-swift-sdk](https://github.com/feedhenry/fh-ios-swift-sdk).

If you do not have access to a RHMAP instance, you can sign up for a free instance at [https://openshift.feedhenry.com/](https://openshift.feedhenry.com/).

## How do I run it?  

### RHMAP Studio

This application and its cloud services are available as a project template in RHMAP as part of the "Native iOS Hello World Project" template.

### Local Clone (ideal for Open Source Development)

If you wish to contribute to this template, the following information may be helpful; otherwise, RHMAP and its build facilities are the preferred solution.

## Build instructions

1. Clone this project
1. Populate ```iOS-Template-App/fhconfig.plist``` with your values as explained [here](https://access.redhat.com/documentation/en-us/red_hat_mobile_application_platform_hosted/3/html/client_sdk/native-ios-swift).
1. Run ```pod install```
1. Open Helloworld-app-iOS.xcworkspace
1. Run the project

## How does it work?

### Init

In ```helloworld-ios-app/HomeViewController.swift``` the FH.init call is done:
```
override func viewDidLoad() {
    result.contentInset = UIEdgeInsetsMake(20.0, 20.0, 10.0, 10.0);
    super.viewDidLoad()

    // Initialized cloud connection
    FH.init {(resp: Response, error: NSError?) -> Void in
        if let error = error {
            print("FH init failed. Error = \(error)")
            self.result.text = "Please fill in fhconfig.plist file."
        }
        print("initialized OK")
        self.button.hidden = false
    }
}
```

### Cloud call

In ```helloworld-ios-app/HomeViewController.swift``` the FH.init call is done:

```
@IBAction func cloudCall(_ sender: AnyObject) {
    name.endEditing(true)

    let args = ["hello": name.text ?? "world"]

    FH.cloud("hello", method: HTTPMethod.POST,
        args: args as [String : AnyObject]?, headers: nil,
        completionHandler: {(resp: Response, error: NSError?) -> Void in
        if let _ = error {
            print("initialize fail, \(resp.rawResponseAsString)")
            self.button.hidden = true
        }
        if let parsedRes = resp.parsedResponse as? [String:String] {
            self.result.text = parsedRes["msg"]
        }
    })
}
```

### iOS9 and non TLS1.2 backend

If your RHMAP is depoyed without TLS1.2 support, open as source  ```blank-ios-app/blank-ios-app-Info.plist.plist``` uncomment the exception lines:

```
  <!--
  <key>NSAppTransportSecurity</key>
  <dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
  </dict>
   -->
```
