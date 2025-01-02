import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DropBoxRepository {
  Future<String> selectAndUploadImage(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final imageFile = await pickImage();
    if (imageFile != null) {
      if (prefs.getString('accessToken') == null) {
        await refreshAccessToken();
      }
      
      final expirationTime = DateTime.parse(prefs.getString('expirationTime')!);
      print(expirationTime.toString());
      if (expirationTime
          .isBefore(DateTime.now().subtract(const Duration(minutes: 5)))) {
        await refreshAccessToken();
      }
      await uploadToDropbox(
          imageFile, prefs.getString('accessToken') ?? 'nulo');
      final String fileName = imageFile.path.split('\\').last;
      String response =  await getSharedLinkExisted(
          '/$fileName', prefs.getString('accessToken') ?? 'nulo');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Imagen subida correctamente")),
      );
      return response;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se seleccionó ninguna imagen")),
      );
      return '';
    }
  }

  Future<void> refreshAccessToken() async {
    final url = Uri.parse("https://api.dropbox.com/oauth2/token");
    final appKey = dotenv.env['appKeyDropbox'];
    final appSecret = dotenv.env['appSecretDropbox'];
    final refreshToken = dotenv.env['refreshTokenDropbox'];

    // Generar la autorización en Base64
    final base64Authorization = base64Encode(utf8.encode('$appKey:$appSecret'));

    // Configurar encabezados
    final headers = {
      'Authorization': 'Basic $base64Authorization',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    // Crear el cuerpo de la solicitud
    final body = {
      'refresh_token': refreshToken,
      'grant_type': 'refresh_token',
    };

    // Hacer la solicitud POST
    final response = await http.post(url, headers: headers, body: body);

    // Procesar la respuesta
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Access Token: ${responseData}');

      final newAccessToken = responseData['access_token'];
      final expiresIn = responseData['expires_in']; // Tiempo en segundos
      final expirationTime = DateTime.now().add(Duration(seconds: expiresIn));
      saveTokenData(
        newAccessToken,
        expirationTime,
        refreshToken!,
      );
    } else {
      print('Failed to refresh token. Status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<String> getSharedLinkExisted(String path, String accessToken) async {  
  final response = await http.post(
    Uri.parse('https://api.dropboxapi.com/2/sharing/list_shared_links'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'path': path,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['links'].isNotEmpty) {
      String sharedLink = data['links'][0]['url'];
      if (!sharedLink.contains('dropbox.com')) {
          throw Exception('El enlace no parece ser de Dropbox');
        }

        // Reemplaza "www.dropbox.com" con "dl.dropboxusercontent.com"
        return sharedLink
            .replaceFirst('www.dropbox.com', 'dl.dropboxusercontent.com')
            .replaceAll('?dl=0', '');
    } else {
      return getSharedLink(path,accessToken);  // Crea el enlace si no existe
    }
  } else {
    throw Exception('Error al obtener el enlace: ${response.body}');
  }
}


  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<bool> checkFileExists(String path,String accessToken) async {
    final response = await http.post(
      Uri.parse('https://api.dropboxapi.com/2/files/get_metadata'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'path': path}),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 409) {
      return false;
    } else {
      throw Exception('Error al verificar el archivo');
    }
  }

  void saveTokenData(
      String accessToken, DateTime expirationTime, String refreshToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', accessToken);
    prefs.setString('expirationTime', expirationTime.toIso8601String());
    prefs.setString('refreshToken', refreshToken);
  }

  Future<void> uploadToDropbox(File imageFile, String accessToken) async {
    // Extraer el nombre del archivo desde la ruta completa
    final String fileName =
        imageFile.path.split('\\').last; // Soporta rutas en Windows

    // Limpiar el nombre del archivo (reemplazar caracteres no válidos)
    final String validFileName =
        fileName.replaceAll(RegExp(r'[\\:*?"<>|]'), '_');

    final String url = "https://content.dropboxapi.com/2/files/upload";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $accessToken", // Token de autenticación
          "Dropbox-API-Arg": jsonEncode({
            "path": "/$validFileName", // El nombre del archivo en Dropbox
            'mode': 'overwrite',
            "autorename": true,
            "mute": false,
          }),
          "Content-Type": "application/octet-stream",
        },
        body: await imageFile.readAsBytes(), // Leer los bytes del archivo
      );

      if (response.statusCode == 200) {
        print("Imagen subida correctamente: ${response.body}");
      } else {
        print("Error al subir la imagen: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<String> getSharedLink(String filePath, String accessToken) async {
    final String url =
        "https://api.dropboxapi.com/2/sharing/create_shared_link_with_settings";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "path": filePath, // Ruta en Dropbox (debe incluir el "/" inicial)
          "settings": {
            "requested_visibility":
                "public", // Asegura que el enlace sea público
          },
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String sharedLink = data['url'];
        if (!sharedLink.contains('dropbox.com')) {
          throw Exception('El enlace no parece ser de Dropbox');
        }

        // Reemplaza "www.dropbox.com" con "dl.dropboxusercontent.com"
        return sharedLink
            .replaceFirst('www.dropbox.com', 'dl.dropboxusercontent.com')
            .replaceAll('?dl=0', '');

        // Si necesitas usar el enlace directamente, puedes devolverlo o guardarlo
      } else {
        print("Error al crear el enlace compartido: ${response.body}");
        return '';
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
