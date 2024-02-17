import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GetPref {
  FlutterSecureStorage secure = const FlutterSecureStorage();

  writeSecureData(String key, String value) async {
    await secure.write(
      key: key, 
      value: value,
      iOptions: _getIOSOptions(),
    );
  }

  IOSOptions _getIOSOptions() =>  IOSOptions(
    accessibility: IOSAccessibility.first_unlock
  );

  Future<String?> readSecureData(String key) async {
    var readData = await secure.read(key: key, iOptions: _getIOSOptions());
    return readData;
  }
}