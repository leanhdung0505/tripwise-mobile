import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> translateToEnglish(String text, {String from = 'auto'}) async {
  final response = await http.post(
    Uri.parse('https://libretranslate.de/translate'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'q': text,
      'source': from,
      'target': 'vi',
      'format': 'text',
    }),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['translatedText'] as String;
  } else {
    throw Exception('Failed to translate');
  }
}