import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reminder_app/local_notification_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  DataConnectionStatus _addressCheckResult = DataConnectionStatus.disconnected;
  final Connectivity _connectivity = Connectivity();
  final DataConnectionChecker _checker = DataConnectionChecker();
  late StreamSubscription<DataConnectionStatus> _adressSubscription;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  get developer => null;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _adressSubscription =
        _checker.onStatusChange.listen(_updateDataConnectionStatus);
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
    if (_addressCheckResult == DataConnectionStatus.connected) {
      if (_connectionStatus == ConnectivityResult.mobile) {
        LocalNoticeService().addNotification(
            'Your connection status', 'Your internet connection: Mobile',
            channel: 'mobile-connection');
      } else if (_connectionStatus == ConnectivityResult.wifi) {
        LocalNoticeService().addNotification(
            'Your connection status', 'Your internet connection: Wi-Fi',
            channel: 'wifi-connection');
      }
    } else {
      LocalNoticeService().addNotification(
          'Your connection status', 'Your internet connection: Disconnect',
          channel: 'mobile-connection');
    }
  }

  Future<void> _updateDataConnectionStatus(DataConnectionStatus status) async {
    setState(() {
      _addressCheckResult = status;
      statusCheck();
    });
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
    _adressSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String connectionType;
    String connectionStatus;
    switch (_connectionStatus) {
      case ConnectivityResult.mobile:
        connectionType = 'Mobile';
        break;
      case ConnectivityResult.wifi:
        connectionType = 'Wi-Fi';
        break;
      case ConnectivityResult.none:
        connectionType = 'None';
        break;
      default:
        connectionType = 'Undefined';
        break;
    }

    switch (_addressCheckResult) {
      case DataConnectionStatus.connected:
        connectionStatus = 'Connected';
        break;
      case DataConnectionStatus.disconnected:
        connectionStatus = 'Disconnected';
        break;
      default:
        connectionStatus = 'Undefined';
        break;
    }

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
              'Your internet type: $connectionType',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Your internet connection: $connectionStatus',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
