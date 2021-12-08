# Map Me - Flutterized
:earth_americas: This project is a Flutterized version of the [Map Me] project. Tracks your location and see details of the route: speed, elapsed time and distance covered. The goal of the project is to practice recreating the UI elements of [this] image and getting familiar with the [google_maps_flutter] package. (No data gets saved!)


## Screenshots
<p>
  <img src="https://github.com/Ashhas/Mapme/blob/master/screenshot/mapme.gif" width="225">
  <img src="https://github.com/Ashhas/Mapme/blob/master/screenshot/Screenshot_20211024-212207.jpg" width="225"> 
  <img src="https://github.com/Ashhas/Mapme/blob/master/screenshot/Screenshot_20211024-212219.jpg" width="225">
 </p>
 

## Download
Because of the *Google Maps API Key*, it could cost me if there are a lot of users the app. So for the meantime, I'll keep the APK in [Releases] and might remove it after some time.


## Features ✔️
* Detect the current location of the user
* Draw the route between start location and current location using Polylines
* Calculate the actual distance of the route
* Stopwatch to time the walk


## Made With 🛠
- [bloc](https://pub.dev/packages/bloc) - State management library for BLoC design pattern
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) - Widgets that make it easy to integrate blocs and cubits
- [geolocator](https://pub.dev/packages/geolocator) - Geolocation plugin for Flutter
- [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) - Flutter plugin for integrating Google Maps
- [flutter_polyline_points](https://pub.dev/packages/flutter_polyline_points) - Get polyline points to draw on the map
- [equatable](https://pub.dev/packages/equatable) - Implement value based equality
- [intl](https://pub.dev/packages/intl) - Formatting dates
- [stop_watch_timer](https://pub.dev/packages/stop_watch_timer) - Package to easily implement a timer


## Comments
The architecture can be improved. Since it's only possible to get the `dart GoogleMapsController` from the widget itself, I wasn't able to keep all logic-code inside the BLoC. I need to research a better solution to separate the UI and business logic. However the ultimate goal of practising with the UI elements and the google_maps_flutter package has been achieved! 😎

Also, this app works on both Android & IOS. However, the IOS version hasn't been fully tested for functionality.


## How to Build 📱
Note that you need to make a new project in the **Google Cloud Platform**, and enable the **Google Maps API** for that project. Then you need to copy the API Key and add it to the code in multiple locations: 

- Add the key to this file `lib/util/constants.dart`:
  ```dart
    static const String APIKEY = "<-- YOUR API KEY -->";
  ```
 
- Next go to the Android manifest file `android/app/src/main/AndroidManifest.xml` and add your API key here:
  ```xml
  <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
  ```

- Lastly, go to the file `Runner/AppDelegate.swift` and add your API key there as well:
  ```swift
    GMSServices.provideAPIKey("<-- YOUR API KEY -->")
  ```



[Map Me]:https://github.com/swaaz/Mapme
[google_maps_flutter]:https://pub.dev/packages/google_maps_flutter
[Releases]:https://github.com/Ashhas/Mapme/releases
[this]:https://github.com/swaaz/Mapme/blob/main/readme/mockup.png
