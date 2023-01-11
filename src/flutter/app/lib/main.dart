import 'package:app/configure_supabase.dart';
import 'package:app/onboarding_page.dart';
import 'package:app/routing.dart';
import 'package:app/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bluetooth/ble/ble_device_connector.dart';
import 'bluetooth/ble/ble_device_interactor.dart';
import 'bluetooth/ble/ble_logger.dart';
import 'bluetooth/ble/ble_scanner.dart';
import 'bluetooth/ble/ble_status_monitor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final _ble = FlutterReactiveBle();
  final _bleLogger = BleLogger(ble: _ble);
  final _scanner = BleScanner(ble: _ble, logMessage: _bleLogger.addToLog);
  final _monitor = BleStatusMonitor(_ble);
  final _connector = BleDeviceConnector(
      ble: _ble, logMessage: _bleLogger.addToLog, scanner: _scanner);
  final _serviceDiscoverer = BleDeviceInteractor(
    bleDiscoverServices: _ble.discoverServices,
    readCharacteristic: _ble.readCharacteristic,
    writeWithResponse: _ble.writeCharacteristicWithResponse,
    writeWithOutResponse: _ble.writeCharacteristicWithoutResponse,
    subscribeToCharacteristic: _ble.subscribeToCharacteristic,
    logMessage: _bleLogger.addToLog,
  );

  await configureApp(); // Awaiting the configuration of the app

  final prefs = await SharedPreferences
      .getInstance(); // Getting the shared preferences instance
  final showHome = prefs.getBool('showHome') ??
      false; // Getting the value for 'showHome' from the shared preferences, or false if it does not exist

  runApp(MultiProvider(
      providers: [
        Provider.value(value: _scanner),
        Provider.value(value: _monitor),
        Provider.value(value: _connector),
        Provider.value(value: _serviceDiscoverer),
        Provider.value(value: _bleLogger),
        StreamProvider<BleScannerState?>(
          create: (_) => _scanner.state,
          initialData: const BleScannerState(
            connectedDevices: [],
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus?>(
          create: (_) => _monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => _connector.state,
          initialData: const ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
        ),
      ],
      child: MyApp(
        showHome: showHome,
      )));
}

class MyApp extends StatelessWidget {
  final bool showHome; // Declaring a boolean variable 'showHome'

  const MyApp({
    Key? key,
    required this.showHome, // The 'showHome' variable is required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: showHome
          ? Routing()
          : OnBoardingPage(), // If showHome is true, display the Routing widget, otherwise display the OnBoardingPage
      debugShowCheckedModeBanner: false, // Don't show the debug banner
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize; // The preferred size of the app bar
  final navigatorKey =
      GlobalKey<NavigatorState>(); // A key to access the app's navigator
  final String title; // The title to display in the app bar
  final bool showOptions;

  CustomAppBar(this.title, {Key? key, this.showOptions = true})
      : preferredSize =
            Size.fromHeight(50.0), // Set the app bar's preferred height to 50.0
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title ?? 'TeamNL'), // Set the app bar's title to 'TeamNL'
      centerTitle: true,
      backgroundColor:
          Color(0xFFF59509), // Set the background color to a hex color code
      actions: [
        if (showOptions)
          PopupMenuButton(
              itemBuilder: (ctx) => [
                    const PopupMenuItem(
                        value: "Settings", child: Text("Settings"))
                  ], // Set the items in the popup menu to a single 'Settings' option
              onSelected: (result) {
                if (title != "Settings") {
                  // If the selected item is not 'Settings'
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Settings()));
                }
              })
      ],
    );
  }
}
