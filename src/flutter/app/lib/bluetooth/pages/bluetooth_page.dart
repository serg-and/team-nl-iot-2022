import 'dart:math';

import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mdsflutter/Mds.dart';

import 'bluetooth_find_device.dart';
import 'bluetooth_off_page.dart';
import '../widgets.dart';

class Bluetooth extends StatelessWidget {
  const Bluetooth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Bluetooth"),
      body: Container(
        child: StreamBuilder<BluetoothState>(
            stream: FlutterBluePlus.instance.state,
            initialData: BluetoothState.unknown,
            builder: (c, snapshot) {
              final state = snapshot.data;
              if (state == BluetoothState.on) {
                return const FindDevicesScreen();
              }
              return BluetoothOffScreen(state: state);
            }),
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) =>
          ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) =>
                  CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () async {
                      await c.write(_getRandomBytes(), withoutResponse: true);
                      await c.read();
                    },
                    onNotificationPressed: () async {
                      await c.setNotifyValue(!c.isNotifying);
                      await c.read();
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) =>
                          DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () => d.write(_getRandomBytes()),
                          ),
                    )
                        .toList(),
                  ),
            )
                .toList(),
          ),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () =>
                  {
                    device.connect().whenComplete(() =>
                        Mds.connect(
                            device.id.toString(), (serial) {
                          Mds.get(Mds.createRequestUri(serial, "/heartbeat"),
                              "",
                                  (data, statusCode) {
                                    print(data);
                                  },
                                  (error, statusCode) { /* onError */ }
                          );
                        }, () {}, () {}))
                  };
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return TextButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme
                        .of(context)
                        .primaryTextTheme
                        .button
                        ?.copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) =>
                  ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        snapshot.data == BluetoothDeviceState.connected
                            ? const Icon(Icons.bluetooth_connected)
                            : const Icon(Icons.bluetooth_disabled),
                        snapshot.data == BluetoothDeviceState.connected
                            ? StreamBuilder<int>(
                            stream: rssiStream(),
                            builder: (context, snapshot) {
                              return Text(
                                  snapshot.hasData ? '${snapshot.data}dBm' : '',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .caption);
                            })
                            : Text('', style: Theme
                            .of(context)
                            .textTheme
                            .caption),
                      ],
                    ),
                    title: Text(
                        'Device is ${snapshot.data.toString().split('.')[1]}.'),
                    subtitle: Text('${device.id}'),
                    trailing: StreamBuilder<bool>(
                      stream: device.isDiscoveringServices,
                      initialData: false,
                      builder: (c, snapshot) =>
                          IndexedStack(
                            index: snapshot.data! ? 1 : 0,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () => device.discoverServices(),
                              ),
                              const IconButton(
                                icon: SizedBox(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        Colors.grey),
                                  ),
                                  width: 18.0,
                                  height: 18.0,
                                ),
                                onPressed: null,
                              )
                            ],
                          ),
                    ),
                  ),
            ),
            StreamBuilder<int>(
              stream: device.mtu,
              initialData: 0,
              builder: (c, snapshot) =>
                  ListTile(
                    title: const Text('MTU Size'),
                    subtitle: Text('${snapshot.data} bytes'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => device.requestMtu(223),
                    ),
                  ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: const [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data!),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Stream<int> rssiStream() async* {
    var isConnected = true;
    final subscription = device.state.listen((state) {
      isConnected = state == BluetoothDeviceState.connected;
    });
    while (isConnected) {
      yield await device.readRssi();
      await Future.delayed(const Duration(seconds: 1));
    }
    subscription.cancel();
    // Device disconnected, stopping RSSI stream
  }
}
