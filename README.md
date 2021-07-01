# Flutter & Unity Sample CI (Github Action + FastLane)

## Prerequisites

- Flutter latest stable version
- Unity 2019.4.27f1 LTS
- [flutter_unity_widget 4.2.0](https://pub.dev/packages/flutter_unity_widget)

## CheckList

### Locally
- [x] Unity: Auto build and config iOS
- [x] Unity: Auto build and config Android
- [x] Fastlane: iOS
- [x] Fastlane: Android
### Github Action
- [x] Game CI: Export unity iOS
- [x] Game CI: Export unity Android
- [x] Fastlane: iOS
- [x] Fastlane: Android

## How it work

### Create `Flutter project` wrap with `unity modunle` via `flutter_unity_widget` package

```
├─ ios
├─ android
├─ lib
  ├─ main.dart
├─ unity
  ├─ unity-project
    ├─ Assets
├─ pubspec.yaml
```

### Setup export unity (iOS/Android) automatic via C# static function.

Create make file and prepare commend line that use unity to excuse C# function.

```Makefile

unity_app = /Applications/Unity/Hub/Editor/2019.4.27f1/Unity.app/Contents/MacOS/Unity
project_path = unity/unity_project/
# all: unity_ios unity_android
unity_ios:
	${unity_app} -quit -bachmode -projectPath ${project_path} -executeMethod Build.DoBuildIOS


unity_android:
	${unity_app} -quit -bachmode -projectPath ${project_path} -executeMethod Build.DoBuildAndroid
```

The result after export succeeded

```
├─ ios
  ├─ UnityLibrary
├─ android
  ├─ unityLibrary
├─ lib
  ├─ main.dart
├─ unity
  ├─ unity-project
    ├─ Assets
├─ pubspec.yaml
```

### Fastlane

- Setup fastlane separately for ios and android. After that we got
```
├─ ios
  ├─ UnityLibrary
  ├─ fastlane
  ├─ Gemfile
├─ android
  ├─ unityLibrary
  ├─ fastlane
  ├─ Gemfile
├─ lib
  ├─ main.dart
├─ unity
  ├─ unity-project
    ├─ Assets
├─ pubspec.yaml
```

- Fastlane Android

```ruby
  desc "Deploy Android"
  lane :firebase do
    sh "flutter build apk"
    # upload_to_play_store
  end
```

- Fastlane iOS

```ruby
  desc "Push a new beta build to TestFlight"
  lane :beta do
    match
    update_code_signing_settings
    build_app
    # testflight
  end
```

### Github Action

Create 2 file to build and deploy via github action (main_android.yml & main_ios.yml) 
#### Android steps
1. Checkout your source code
2. Cache Unity Library
3. Build Unity Android
4. Set up Flutter
5. Fix File permission
6. Build and deploy with Fastlane
#### iOS steps
Because build unity not available on macOS. So we export unity first on ubuntu
**I. Export Unity on Ubuntu**
1. Checkout your source code
2. Cache Unity Library
3. Build Unity Android
4. Upload Build to Artifact

**II. Build Flutter iOS on MacOS**
1. Checkout your source code
2. Download Build from Artifact
2. Set up Flutter
3. Fix File permission
4. Build and deploy with Fastlane

> Note: After export unity. I don't know why we don't have permission to write on our source code. So we need use `chmod` to fix permission
