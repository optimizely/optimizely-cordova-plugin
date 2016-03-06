# Optimizely Cordova Plugin

Cordova Plugin for the Optimizely iOS and Android SDKs

Allows developers developing hybrids apps using Cordova platforms such as Phonegap, Crosswalk, Ionic, Intel XDK to use the Optimizely SDKs for A/B
testing and beyond!

- [Android SDK Version 1.4.1](http://developers.optimizely.com/android/changelog/index.html#\31 -4-1)
- [iOS SDK Version 1.4.0](http://developers.optimizely.com/ios/changelog/index.html#\31 -4-0)


## Usage

### 1. Download plugin
```
git clone https://github.com/optimizely/optimizely-cordova-plugin
```

### 2. Install into project
```
cd into root of your cordova/phonegap project
cordova plugin add <PATH TO PLUGIN>
```

### 3. Build your app
```
cordova build
```

### 4. Use the `optimizely` object to make API calls


## Start A/B Testing!

1. If you haven't already, sign up for an account at [Optimizely](www.optimizely.com/mobile)

2. Create a Android or iOS project

3. Grab your project token

4. Call startOptimizely with your token
```
window.optimizely.startOptimizely(<token>, successCallback, errorCallback)
```


More documentation coming soon!
