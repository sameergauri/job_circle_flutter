import 'package:flutter/material.dart';
import 'package:job_circle/my_app.dart';
import 'package:job_circle/provider_scop.dart';
import 'package:job_circle/src/services/deeplink/deeplink_service.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Deep lin initialization..
  await DeepLinkService().initDeepLinks();
  await SharedPrefsHelper.init(); // Initialize SharedPreferenceszz
  runApp(ProviderScop.setupProviders(child: const MyApp()));
}
