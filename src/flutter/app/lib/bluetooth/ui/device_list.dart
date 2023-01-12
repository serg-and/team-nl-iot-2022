import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import '../../sensor.dart';
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
                      // The connected devices can only be movesense right now
                      leading: Image.asset("assets/Images/movesense.png"),
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
                            'count: ${widget.scannerState.discoveredDevices.where((element) => selectedSensorList!.length == 0 ? sensorList.where((selected) => element.name.toString().toLowerCase().contains(selected.name.toString().toLowerCase())).length > 0 : selectedSensorList!.where((selected) => element.name.toString().toLowerCase().contains(selected.name.toString().toLowerCase())).length > 0).length}',
                          )
                        : null,
                  ),
                  ...widget.scannerState.discoveredDevices
                      .map(
                        (device) => ListTile(
                          title: Text(device.name),
                          subtitle: Text("${device.id}\nRSSI: ${device.rssi}"),
                          leading: sensorList
                                      .where((sensor) => device.name
                                          .toLowerCase()
                                          .contains(sensor.name!.toLowerCase()))
                                      .length >
                                  0
                              ? Image.asset("assets/Images/" +
                                  sensorList
                                      .where((sensor) => device.name
                                          .toLowerCase()
                                          .contains(sensor.name!.toLowerCase()))
                                      .first
                                      .name!
                                      .toLowerCase()
                                      .toString() +
                                  ".png")
                              : BluetoothIcon(),
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
                      .where((element) => selectedSensorList!.length == 0
                          ? sensorList
                                  .where((selected) => element.title
                                      .toString()
                                      .toLowerCase()
                                      .contains(selected.name
                                          .toString()
                                          .toLowerCase()))
                                  .length >
                              0
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

class FilterPage extends StatelessWidget {
  const FilterPage({Key? key, this.allTextList, this.selectedSensorList})
      : super(key: key);
  final List<Sensor>? allTextList;
  final List<Sensor>? selectedSensorList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensors to connect"),
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
          onItemSearch: (item, query) {
            /// When search query change in search bar then this method will be called
            ///
            /// Check if items contains query
            return item.name!.toLowerCase().contains(query.toLowerCase());
          },
        ),
      ),
    );
  }
}
