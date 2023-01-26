import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:mdsflutter/Mds.dart';
import 'package:provider/provider.dart';
import '../models/device.dart';
import '../models/device_model.dart';

// This class is a stateful widget that displays a list of device interaction options
// such as subscribing to accelerometer data, heart rate data, and controlling the LED
class DeviceInteractionWidget extends StatefulWidget {
  final Device device;
  final List<DiscoveredService> discoveredServices;
  final Future<List<int>> Function(QualifiedCharacteristic characteristic)
      readCharacteristic;

  // Constructor that initializes the device field
  const DeviceInteractionWidget(
      this.device, this.discoveredServices, this.readCharacteristic);

  // Creates the state for this widget
  @override
  State<StatefulWidget> createState() {
    return _DeviceInteractionWidgetState(device);
  }
}

// This class represents the state for the DeviceInteractionWidget
class _DeviceInteractionWidgetState extends State<DeviceInteractionWidget> {
  // This field represents the device for which the interactions are being displayed
  late Device device;

  // Constructor that initializes the device field
  _DeviceInteractionWidgetState(Device givenDevice) {
    this.device = givenDevice;
  }

  // This method is called when the state is initialized
  @override
  void initState() {
    super.initState();
  }

  // This method is called when the "Subscribe"/"Unsubscribe" button for the accelerometer is pressed
  void _onAccelerometerButtonPressed(DeviceModel deviceModel) {
    // If the user is currently subscribed to accelerometer data, unsubscribe them
    if (deviceModel.accelerometerSubscribed) {
      deviceModel.unsubscribeFromAccelerometer();
    }
    // If the user is not currently subscribed to accelerometer data, subscribe them
    else {
      deviceModel.subscribeToAccelerometer();
    }
  }

  void _onHrButtonPressed(DeviceModel deviceModel) {
    if (deviceModel.hrSubscribed) {
      deviceModel.unsubscribeFromHr();
    } else {
      deviceModel.subscribeToHr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DeviceModel(device.name, device.serial),
      child: Consumer<DeviceModel>(
        builder: (context, model, child) {
          return Container(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _batteryLevelItem(model),
              _accelerometerItem(model),
              _hrItem(model),
              _ledItem(model),
              _temperatureItem(model)
            ],
          ));
        },
      ),
    );
  }

  Widget _batteryLevelItem(DeviceModel deviceModel) {
    var char = widget.discoveredServices[3].characteristics.first;
    var level = "";
    var ft = widget.readCharacteristic(new QualifiedCharacteristic(
        characteristicId: char.characteristicId,
        serviceId: char.serviceId,
        deviceId: device.address.toString()));
    return Card(
      child: FutureBuilder<List<int>>(
        future: ft,
        builder: (context, snapshot) {
          return ListTile(
            title: Text("Battery Level"),
            subtitle: Text(snapshot.data?.first.toString() ?? ""),
          );
        },
      ),
    );
  }

  Widget _accelerometerItem(DeviceModel deviceModel) {
    return Card(
      child: ListTile(
        title: Text("Accelerometer"),
        subtitle: deviceModel.accelerometerSubscribed
            ? Text(deviceModel.accelerometerData)
            : Text(""),
        trailing: Switch(
          activeColor: Colors.orange,
          value: deviceModel.accelerometerSubscribed,
          onChanged: (value) => {_onAccelerometerButtonPressed(deviceModel)},
        ),
      ),
    );
  }

  Widget _hrItem(DeviceModel deviceModel) {
    return Card(
      child: ListTile(
        title: Text("Heart rate"),
        subtitle:
            deviceModel.hrSubscribed ? Text(deviceModel.hrData) : Text(""),
        trailing: Switch(
          activeColor: Colors.orange,
          value: deviceModel.hrSubscribed,
          onChanged: (value) => {_onHrButtonPressed(deviceModel)},
        ),
      ),
    );
  }

  Widget _ledItem(DeviceModel deviceModel) {
    return Card(
      child: ListTile(
        title: Text("Led"),
        trailing: Switch(
          activeColor: Colors.orange,
          value: deviceModel.ledStatus,
          onChanged: (b) => {deviceModel.switchLed()},
        ),
      ),
    );
  }

  Widget _temperatureItem(DeviceModel deviceModel) {
    return Card(
      child: ListTile(
        title: Text("Temperature"),
        subtitle: Text(deviceModel.temperature),
        trailing: ElevatedButton(
          child: Text("Get", style: TextStyle(color: Colors.white)),
          onPressed: () => deviceModel.getTemperature(),
          style: ElevatedButton.styleFrom(primary: Colors.orange),
        ),
      ),
    );
  }
}
