import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/routes/router.dart';
import 'package:job_circle/screens/jobs/job_details.dart';
import 'package:job_circle/themes/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
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
      initialRoute: ERoute.jobs.toString(),
    );
  }
}
