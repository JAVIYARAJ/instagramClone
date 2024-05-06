import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/route_generator.dart';
import 'package:instagram_clone/screens/auth/bloc/auth_bloc.dart';
import 'package:instagram_clone/screens/home/bloc/home_bloc.dart';
import 'package:instagram_clone/screens/post/bloc/post_bloc.dart';
import 'package:instagram_clone/screens/search/bloc/search_bloc.dart';
import 'package:instagram_clone/screens/splash/view/splash_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyC2rZKcmhY79jnzjGyFfRHi3QUNd3q14GY',
            appId: '1:539995017670:web:2b25d86c92be73271762c7',
            messagingSenderId: '539995017670',
            projectId: 'instagram-clone-84a9b',
            storageBucket: 'instagram-clone-84a9b.appspot.com'));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => PostBloc(),
        ),
        BlocProvider(
          create: (context) => SearchBloc(),
        )
      ],
      child: GlobalLoaderOverlay(
        overlayWidgetBuilder: (progress) {
          return Center(
            child: Lottie.asset("assets/ic_loading_animation.json",
                width: 120, height: 120, fit: BoxFit.cover),
          );
        },
        useDefaultLoading: false,
        overlayColor: Colors.grey.withOpacity(0.8),
        overlayWholeScreen: true,
        child: MaterialApp(
          theme: ThemeData.dark()
              .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
          debugShowCheckedModeBanner: false,
          title: 'Instagram',
          onGenerateRoute: RouteGenerator.generateRoute,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
