import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/routes/router.dart';
import 'package:job_circle/themes/colors.dart';

import 'interceptors/no_internet.dart';

void main() {
  // FlutterError.demangleStackTrace = (stackTrace) => stackTrace;
  /* FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details, forceReport: true);
  }; */
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your 0application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));

    return ScreenUtilInit(
        designSize: const Size(414, 896),
        builder: (BuildContext context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Job Circle',
            theme: ThemeData(
                useMaterial3: false,
                fontFamily: GoogleFonts.varela.toString(),
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primaryColor: Constants.themeBgColor,
                primarySwatch: Constants.theme),
            routes: ApplicationRouter.appRouter,
            // onGenerateRoute: (settings) {
            //   if (settings.name == ERoute.jobsdetail.name) {
            //     final args = settings.arguments;

            //     // Then, extract the required data from the arguments and
            //     // pass the data to the correct screen.
            //     return MaterialPageRoute(builder: (context) {
            //       return JobDetails(i);
            //     });
            //   }
            // },
            initialRoute:
                const NoInternet().toString(), //ERoute.jobs.toString(),
          );
        });
  }
}
