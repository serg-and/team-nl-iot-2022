import 'dart:math';

import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import '../ble/ble_logger.dart';
import '../ble/ble_scanner.dart';
import '../widgets.dart';
import 'device_detail/device_detail_screen.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer3<BleScanner, BleScannerState?, BleLogger>(
        builder: (_, bleScanner, bleScannerState, bleLogger, __) => _DeviceList(
          scannerState: bleScannerState ??
              const BleScannerState(
                connectedDevices: [],
                discoveredDevices: [],
                scanIsInProgress: false,
              ),
          startScan: bleScanner.startScan,
          stopScan: bleScanner.stopScan,
          toggleVerboseLogging: bleLogger.toggleVerboseLogging,
          verboseLogging: bleLogger.verboseLogging,
        ),
      );
}

class _DeviceList extends StatefulWidget {
  const _DeviceList({
    required this.scannerState,
    required this.startScan,
    required this.stopScan,
    required this.toggleVerboseLogging,
    required this.verboseLogging,
  });

  final BleScannerState scannerState;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;
  final VoidCallback toggleVerboseLogging;
  final bool verboseLogging;

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<_DeviceList> {
  late TextEditingController _uuidController;
  List<Sensor>? selectedSensorList = [];

  @override
  void initState() {
    super.initState();
    _uuidController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    widget.stopScan();
    _uuidController.dispose();
    super.dispose();
  }

  bool _isValidUuidInput() {
    final uuidText = _uuidController.text;
    if (uuidText.isEmpty) {
      return true;
    } else {
      try {
        Uuid.parse(uuidText);
        return true;
      } on Exception {
        return false;
      }
    }
  }

  void _startScanning() {
    final text = _uuidController.text;
    widget.startScan(text.isEmpty ? [] : [Uuid.parse(_uuidController.text)]);
    print(selectedSensorList?.first.name);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Scan for devices'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: const Text('Scan'),
                        onPressed: !widget.scannerState.scanIsInProgress
                            ? _startScanning
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final list = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilterPage(
                                allTextList: sensorList,
                                selectedSensorList: selectedSensorList,
                              ),
                            ),
                          );
                          if (list != null) {
                            setState(() {
                              selectedSensorList = List.from(list);
                            });
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange),
                        ),
                        child: const Text(
                          "Scan Filter",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        child: const Text('Stop'),
                        onPressed: widget.scannerState.scanIsInProgress
                            ? widget.stopScan
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                children: [
                  SwitchListTile(
                    title: const Text("Verbose logging"),
                    value: widget.verboseLogging,
                    onChanged: (_) => setState(widget.toggleVerboseLogging),
                  ),
                  ListTile(
                    trailing: (widget.scannerState.scanIsInProgress ||
                            widget.scannerState.discoveredDevices.isNotEmpty)
                        ? Text(
                            'connected count: ${widget.scannerState.connectedDevices.length}',
                          )
                        : null,
                  ),
                  ...widget.scannerState.connectedDevices.map(
                    (device) => ListTile(
                      title: Text(device.name),
                      subtitle: Text("${device.id}\nRSSI: ${device.rssi}"),
                      leading: Image.asset("assets/Images/ms.png"),
                      onTap: () async {
                        widget.stopScan();
                        await Navigator.push<void>(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    DeviceDetailScreen(device: device)));
                      },
                    ),
                  ),
                  ListTile(
                    trailing: (widget.scannerState.scanIsInProgress ||
                            widget.scannerState.discoveredDevices.isNotEmpty)
                        ? Text(
                            'count: ${widget.scannerState.discoveredDevices.where((element) => selectedSensorList!.length <= 0 ? true : selectedSensorList!.where((selected) => element.name.toString().toLowerCase().contains(selected.name.toString().toLowerCase())).length > 0).length}',
                          )
                        : null,
                  ),
                  ...widget.scannerState.discoveredDevices
                      .map(
                        (device) => ListTile(
                          title: Text(device.name),
                          subtitle: Text("${device.id}\nRSSI: ${device.rssi}"),
                          leading: Image.asset("assets/Images/ms.png"),
                          onTap: () async {
                            widget.stopScan();
                            await Navigator.push<void>(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        DeviceDetailScreen(device: device)));
                          },
                        ),
                      )
                      .where((element) => selectedSensorList!.length <= 0
                          ? true
                          : selectedSensorList!
                                  .where((selected) => element.title
                                      .toString()
                                      .toLowerCase()
                                      .contains(selected.name
                                          .toString()
                                          .toLowerCase()))
                                  .length >
                              0)
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Sensor>? selectedSensorList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // TextButton(
            //   onPressed: () async {
            //     final list = await Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => FilterPage(
            //           allTextList: sensorList,
            //           selectedSensorList: selectedSensorList,
            //         ),
            //       ),
            //     );
            //     if (list != null) {
            //       setState(() {
            //         selectedSensorList = List.from(list);
            //       });
            //     }
            //   },
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
            //   ),
            //   child: const Text(
            //     "Filter",
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          if (selectedSensorList == null || selectedSensorList!.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No Sensor selected'),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(selectedSensorList![index].name!),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: selectedSensorList!.length,
              ),
            ),
        ],
      ),
    );
  }
}

class FilterPage extends StatelessWidget {
  const FilterPage({Key? key, this.allTextList, this.selectedSensorList})
      : super(key: key);
  final List<Sensor>? allTextList;
  final List<Sensor>? selectedSensorList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensors that you want to connect discover"),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: FilterListWidget<Sensor>(
          themeData: FilterListThemeData(context),
          hideSelectedTextCount: true,
          listData: sensorList,
          selectedListData: selectedSensorList,
          onApplyButtonClick: (list) {
            Navigator.pop(context, list);
          },
          choiceChipLabel: (item) {
            /// Used to print text on chip
            return item!.name;
          },
          validateSelectedItem: (list, val) {
            ///  identify if item is selected or not
            return list!.contains(val);
          },
          onItemSearch: (user, query) {
            /// When search query change in search bar then this method will be called
            ///
            /// Check if items contains query
            return user.name!.toLowerCase().contains(query.toLowerCase());
          },
        ),
      ),
    );
  }
}

class Sensor {
  final String? name;
  Sensor({this.name});
}

/// Creating a global list for example purpose.
/// Generally it should be within data class or where ever you want
List<Sensor> sensorList = [
  Sensor(name: "MoveSense"),
  Sensor(name: "Polar"),
  Sensor(name: "Huiskamer"),
];
