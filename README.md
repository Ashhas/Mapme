# Map Me - Flutterized

:earth_americas: This is project is a Flutterized version of the [Map Me] project. The goal of the project is to practise recreating UI elements and getting familiar with the [google_maps_flutter] package.

## Screenshots
<p>
  <img src="https://github.com/Ashhas/Mapme/blob/main/screenshot/mapme.gif" width="225">
  <img src="https://github.com/Ashhas/Mapme/blob/main/screenshot/Screenshot_20211024-212207.jpg" width="225"> 
  <img src="https://github.com/Ashhas/Mapme/blob/main/screenshot/Screenshot_20211024-212219.jpg" width="225">
 </p>

## Made With 🛠
Plugins | Usage
------------ | -------------
[bloc](https://pub.dev/packages/bloc) | State management library for BLoC design pattern
[flutter_bloc](https://pub.dev/packages/flutter_bloc) | Widgets that make it easy to integrate blocs and cubits
[geolocator](https://pub.dev/packages/geolocator) | Geolocation plugin for Flutter
[google_maps_flutter](https://pub.dev/packages/google_maps_flutter) | Flutter plugin for integrating Google Maps
[flutter_polyline_points](https://pub.dev/packages/flutter_polyline_points) | Get polyline points to draw on the map
[equatable](https://pub.dev/packages/equatable) | Implement value based equality
[intl](https://pub.dev/packages/intl) | Formatting dates
[stop_watch_timer](https://pub.dev/packages/stop_watch_timer) | Package to easily implement a timer


## How to Build 📱

Note that you will need to make a new project in the **Google Cloud Platform**, and enable the **Google Maps API** for that project. Then you need to copy the API Key and it to the code in multiple locations: 

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
