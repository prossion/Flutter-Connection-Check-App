import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reminder_app/local_notification_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  get developer => null;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  void statusCheck() {
    if (_connectionStatus == ConnectivityResult.mobile) {
      LocalNoticeService().addNotification(
          'You\'re connection status', 'You\'re internet connection: Mobile',
          channel: 'mobile-connection');
    } else if (_connectionStatus == ConnectivityResult.wifi) {
      LocalNoticeService().addNotification(
          'You\'re connection status', 'You\'re internet connection: Wi-Fi',
          channel: 'wifi-connection');
    } else {
      LocalNoticeService().addNotification(
          'You\'re connection status', 'You\'re internet connection: None',
          channel: 'none-connection');
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      statusCheck();
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Check Internet Connection',
                style: TextStyle(fontSize: 25)),
            const SizedBox(height: 20),
            Text(
              'You\'re internet connection: ${_connectionStatus.toString()}',
              style: const TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
