import 'dart:async';

import 'package:app/bluetooth/ble/ble_scanner.dart';
import 'package:app/bluetooth/ble/reactive_state.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleDeviceConnector extends ReactiveState<ConnectionStateUpdate> {
  BleDeviceConnector(
      {required FlutterReactiveBle ble,
      required Function(String message) logMessage,
      required BleScanner scanner})
      : _ble = ble,
        _logMessage = logMessage,
        _scanner = scanner;

  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;
  final BleScanner _scanner;

  @override
  Stream<ConnectionStateUpdate> get state => _deviceConnectionController.stream;

  final _deviceConnectionController = StreamController<ConnectionStateUpdate>();

  // ignore: cancel_subscriptions
  late StreamSubscription<ConnectionStateUpdate> _connection;

  Future<void> connect(String deviceId) async {
    _logMessage('Start connecting to $deviceId');
    if (_scanner.connected.where((element) => element.id == deviceId).length >
        0) {
      _scanner.connected.remove(
          _scanner.connected.where((element) => element.id == deviceId).first);
    }
    _scanner.connected
        .add(_scanner.devices.where((element) => element.id == deviceId).first);
    _connection = _ble.connectToDevice(id: deviceId).listen(
      (update) {
        _logMessage(
            'ConnectionState for device $deviceId : ${update.connectionState}');
        _deviceConnectionController.add(update);
      },
      onError: (Object e) =>
          _logMessage('Connecting to device $deviceId resulted in error $e'),
    );
  }

  Future<void> disconnect(String deviceId) async {
    _scanner.connected
        .remove(_scanner.connected.where((element) => element.id == deviceId));
    try {
      _logMessage('disconnecting to device: $deviceId');
      await _connection.cancel();
    } on Exception catch (e, _) {
      _logMessage("Error disconnecting from a device: $e");
    } finally {
      // Since [_connection] subscription is terminated, the "disconnected" state cannot be received and propagated
      _deviceConnectionController.add(
        ConnectionStateUpdate(
          deviceId: deviceId,
          connectionState: DeviceConnectionState.disconnected,
          failure: null,
        ),
      );
    }
  }

  Future<void> dispose() async {
    await _deviceConnectionController.close();
  }
}
