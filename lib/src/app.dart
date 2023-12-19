// ignore_for_file: use_build_context_synchronously

import 'package:clipboard/clipboard.dart';
import 'package:device_identifier/src/utils/alerts.dart';
import 'package:device_identifier/src/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  String deviceInfo = 'Press the button';
  bool hasInformation = false;

  @override
  void initState() {
    super.initState();
    getDeviceId();
  }

  Future<Database> getDatabase() async {
    return openDatabase(
        join(await getDatabasesPath(), 'device_database.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE device_table(id INTEGER PRIMARY KEY, identifier TEXT)',
          );
        },
        version: 1,
    );
  }

  Future<void> saveDeviceId(BuildContext context, String id) async {
    final db = await getDatabase();
    final result = await db.insert('device_table', {'identifier': id});
    if (result != 0) {
      showToast(context, message: 'Saved to database successfully',status: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Device Identifier'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Text(
                  deviceInfo,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () async{
                  if(hasInformation){
                    await FlutterClipboard.copy(deviceInfo);
                    showToast(context, message: 'Text copied to clipboard',status: true);
                  }
                },
              ),
              if(!hasInformation)
              FilledButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                    ),
                  ),
                ),
                onPressed: () async{ 
                   deviceInfo =  await getDeviceId();
                   saveDeviceId(context, deviceInfo);
                    setState((){
                      hasInformation = true;
                    });
                 },
                child: const Text(
                  'identify',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
