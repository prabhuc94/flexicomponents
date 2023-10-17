import 'package:flexicomponents/helper/app_helper_login_provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flexicomponents/flexicomponents.dart';
import 'package:flexicomponents/components/app_component_password_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flexicomponentsPlugin = Flexicomponents();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flexicomponentsPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, __) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          floatingActionButton: FloatingActionButton.small(onPressed: () async {
            var data = await DesktopOAuthManager(onlyWeb: false).SSO();
            print('DATA:\t$data');
          }, mouseCursor: SystemMouseCursors.click, child: Icon(Icons.webhook_rounded)),
          body: Center(
            child: Column(
              children: [
                PasswordTextField(
                    isDense: true,
                    hintText: "Enter password",
                    contentPadding: EdgeInsets.all(10.spMin),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.spMin))),
              ],
            )
          ),
        ),
      ),
      minTextAdapt: true,
      designSize: const Size(360, 690),
    );
  }
}
