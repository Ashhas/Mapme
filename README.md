# Map Me - Flutterized
:earth_americas: This project is a Flutterized version of the [Map Me] project. Track your walking route and see the distance and time. The goal of the project is to practice recreating UI elements and getting familiar with the [google_maps_flutter] package. (No data gets saved!)


## Screenshots
<p>
  <img src="https://github.com/Ashhas/Mapme/blob/main/screenshot/mapme.gif" width="225">
  <img src="https://github.com/Ashhas/Mapme/blob/main/screenshot/Screenshot_20211024-212207.jpg" width="225"> 
  <img src="https://github.com/Ashhas/Mapme/blob/main/screenshot/Screenshot_20211024-212219.jpg" width="225">
 </p>
 

## Download
Because of the *Google Maps API Key*, there could be a cost for me depending on how many users use the app.
So I'll keep the APK in [Releases] for a limited time.


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
- [equatable](https://pub.dev/packages/equatable) vImplement value based equality
- [intl](https://pub.dev/packages/intl) - Formatting dates
- [stop_watch_timer](https://pub.dev/packages/stop_watch_timer) - Package to easily implement a timer


## Comments
The architecture can be improved. Since it's only possible to get the GoogleMapsController from the widget itself, I wasn't able to keep all to logic-code in the BLoC. I have to research a different solution to separate the UI and business logic. However the ultimate goal of practising with the UI elements and the google_maps_flutter package has been achieved! 😎


## How to Build 📱
Note that you need to make a new project in the **Google Cloud Platform**, and enable the **Google Maps API** for that project. Then you need to copy the API Key and it to the code in multiple locations: 

- Add the key to this file `lib/util/constants.dart`:
  ```dart
    static const String APIKEY = "<-- YOUR API KEY -->";
  ```
 
- Next go to the Android manifest file `android/app/src/main/AndroidManifest.xml` and add your API key here:
  ```xml
  <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
  ```




[Map Me]:https://github.com/swaaz/Mapme
[google_maps_flutter]:https://pub.dev/packages/google_maps_flutter
[Releases]:https://github.com/Ashhas/Mapme/releases
