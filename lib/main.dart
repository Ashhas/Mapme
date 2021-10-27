import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_me/bloc/simple_bloc_observer.dart';
import 'package:map_me/bloc/tracking_footer/tracking_footer_bloc.dart';
import 'package:map_me/ui/home_screen.dart';

void main() {
  //Prepare WidgetBinding for platform channels
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Bloc Observer
  Bloc.observer = SimpleBlocObserver();

  //Lock Device Orientation in portrait mode
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TrackingFooterBloc(),
        )
      ],
      child: MaterialApp(
        title: 'MapMe',
        home: HomeScreen(),
      ),
    );
  }
}
