import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';

class KeysService {
  Future<FirebaseOptions?> getKeys() async {
    try {
      final response = await http.get(
        Uri.parse('https://dev.bantenkidsrevival.org/middleware-dev.php'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        FirebaseOptions web = FirebaseOptions(
          apiKey: jsonResponse['apiKey'],
          appId: jsonResponse['appId'],
          messagingSenderId: jsonResponse['messagingSenderId'],
          projectId: jsonResponse['projectId'],
          authDomain: jsonResponse['authDomain'],
          storageBucket: jsonResponse['storageBucket'],
          measurementId: jsonResponse['measurementId'],
        );

        return web;
      } else {
        throw Exception("Gagal mendapatkan keys: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
