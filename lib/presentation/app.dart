import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../generated/l10n.dart';
import '../infrastructure/services/bluetooth_service.dart';
import 'theme.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: createLightTheme(),
      darkTheme: createDarkTheme(),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: 'TempDrop',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final b = Bluetooth();
  bool _scanning;

  @override
  void initState() {
    super.initState();
  }

  void _startScan() {
    setState(() {
      _scanning = true;
      b.startScan().then((_) {
        print('stop');
        _scanning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.refresh_outlined),
                onPressed: _startScan),
          ],
        ),
        body: StreamBuilder<List<ScanResult>>(
          initialData: [],
          stream: b.devices,
          builder: (context, snapshot) {
            Widget body;

            if (snapshot.hasData) {
              final devices =
                  snapshot.data.map((d) => DeviceEntry(device: d)).toList();

              body = ListView(
                children: devices,
              );
            } else {
              body = Container();
            }

            return Stack(
              children: [
                body,
                Opacity(
                  opacity: _scanning ? 1.0 : 0.0,
                  child: LinearProgressIndicator(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DeviceEntry extends StatelessWidget {
  final ScanResult device;

  const DeviceEntry({Key key, this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(device.device.name.contains('Ray')) {
      device.device.discoverServices().then((r) {
        print(r);
      });
    }

    return Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              device.device.name.isEmpty ? '<Unknown>' : device.device.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              device.device.id.id,
            )
          ],
        ),
      ),
    );
  }
}
