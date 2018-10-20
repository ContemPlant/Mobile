# ContemPlant mobile app

This repository contains code for a ContemPlant iOS- and Android-app and all related stuff.

## Usage

### Prerequisites
Development environment:
- macOS >= High Sierra _and_ Xcode >= 10.0 _(for iOS app only)_
- Android Studio _(for Android app only)_
- ReactNative installed _(latest version)_


### Installing

First, make sure you've installed the required software (as described under [Prerequisites](#prerequisites)) and setup all the software, building stuff and profiles as described in various instructions on the internet for the various platforms and development environments.

#### Running the iOS app
Just open [ContemPlant.xcworkspace](./App/iOS/ContemPlant/ContemPlant.xcworkspace) file in Xcode.
Then follow the known steps for deploying an iOS app on either the simulator or a real device using Xcode.


#### Running the android app
Navigate to [that](./App/React.nosync/ContemPlant) directory (```cd```).
Run ```npm install```
Then open the Android project in AndroidStudio and launch it as usual (on a real device or in the emulator).


### Customize the app for your custom environments (IPs and URLs primarily)
The code (as it is in this repository) is written in a way specific to match our backend requirements and it communicates with our servers we used for development and testing. So all URLs and IPs point to our servers. If you wanna use the app with your custom ContemPlant infrastructure and servers (see the [Backend](https://github.com/ContemPlant/Backend) and [Web](https://github.com/ContemPlant/Web) repos as well), you'll need to customize the app at some points in code.

- For iOS the file of interest should be [Constants.swift](./App/iOS/ContemPlant/ContemPlant/Constants.swift)
- For Android the file of interest should be [Constants.js](./App/React.nosync/ContemPlant/app/config/Constants.js)


## Built With

* [ReactNative](https://facebook.github.io/react-native/) - Primarily for developing the Android app
* [GraphQL](https://graphql.org/) - Used for server communication

## Acknowledgements
3D Models based [Algorithmic Botany via Lindenmayer Systems in Blender](https://github.com/lemurni/lpy-lsystems-blender-addon) and [Poly by Google](https://poly.google.com).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
