import 'package:appecommerce/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:appecommerce/ui/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:appecommerce/ui/login_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

   // Initialize Firebase In-App Messaging
  FirebaseInAppMessaging.instance;
  
  Stripe.publishableKey =
      'pk_test_51OZPqXL8vLmen1m4Wq3CaSR3XHdkfxGZJWDdn7ezzF7wpBefCCavRRX07PKuVfez2opcS2AzkmjKUWFHBfVLtJ7T00iDxd5KOR';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Flutter E commerce',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: SplashScreen(),
            
            
            routes: {
              '/login': (context) => LoginScreen(),
              
            },
            
            
            initialRoute: '/',
          );
        },
      ),
    );
  }
}
