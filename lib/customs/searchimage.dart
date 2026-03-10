// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

Future<Uint8List?> getFirstImageUrl(String query) async {
  try {
    // Step 1: Call local proxy server instead of direct API call
    final searchUri = Uri.parse(
      'http://localhost:3000/search?q=${Uri.encodeComponent(query)}',
    );

    final searchResponse = await http.get(searchUri);

    if (searchResponse.statusCode != 200) {
      print('Search failed with status: ${searchResponse.statusCode}');
      print('Response: ${searchResponse.body}');
      return null;
    }

    final downloadData = jsonDecode(searchResponse.body);

    if (downloadData['data'] == null || downloadData['data']['url'] == null) {
      print('No images found for query: $query');
      print('Response: ${searchResponse.body}');
      return null;
    }

    // This is the direct .jpg or .png link
    String imageUrl = downloadData['data']['url'];
    print('Image URL: $imageUrl');
    return fetchImageBytes(imageUrl);
  } catch (e) {
    print("Freepik Error: $e");
  }
  return null;
}

Future<Uint8List> fetchImageBytes(String url) async {
  final response = await http.get(Uri.parse(url));
  return response.bodyBytes; // This is your Uint8List
}
