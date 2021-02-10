import 'package:flutter_blue/flutter_blue.dart';

class Bluetooth {
  final bt = FlutterBlue.instance;

  Future<BluetoothError> start() async {
    if(!await bt.isAvailable) {
      return BluetoothError.unavailable;
    }

    if(!await bt.isOn) {
      return BluetoothError.disabled;
    }

    return BluetoothError.none;
  }

  Future<dynamic> startScan() {
    return bt.startScan(timeout: Duration(seconds: 5));
  }
  void stopScan() => bt.stopScan();
  
  Stream<List<ScanResult>> get devices => bt.scanResults;
  
}

enum BluetoothError {
  none,
  unavailable,
  disabled
}
