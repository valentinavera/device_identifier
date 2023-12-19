import 'dart:convert';

import 'package:crypto/crypto.dart';
// import 'package:device_identifier/src/utils/encrypt.dart';
import 'package:device_identifier/src/utils/encrypt_util.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<String> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? id;
  String deviceKey = '';

  try{

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      id = iosInfo.identifierForVendor;
      deviceKey = iosInfo.name + iosInfo.model;

      if (id == null || id.isEmpty) {
        throw Exception('identifierForVendor is null');
      }else{
        deviceKey +=id;
      }
    }

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      id = androidInfo.id;
      deviceKey = androidInfo.device + id + androidInfo.model;

      if (id.isEmpty) {
        throw Exception('serialNumber is null');
      }
    }

      var hash = sha256.convert(utf8.encode(deviceKey));
      String encryptedKey = hash.toString().substring(0, 32);
      return encryptBody(id!, encryptedKey);


  }catch (_){
    throw Exception('Unsupported platform');
  }

}
