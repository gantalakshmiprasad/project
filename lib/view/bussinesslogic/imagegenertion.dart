// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:appwrite/enums.dart';
import 'package:firstproject/customs/config.dart';
import 'package:firstproject/services/authservices.dart';
import 'package:firstproject/services/storageservice.dart';

Future<Uint8List> imageGeneration(
  Storageservice storageservice,
  AuthServices authservices,
  String promptText,
) async {
  try {
    // BUG FIX: Wrapped structural body parsing maps inside native standard JSON encoders to prevent breaks on user quotes
    final String executionBody = jsonEncode({"prompt": promptText});

    final execution = await authservices.function.createExecution(
      functionId: ApiConfig().functionid,
      method: ExecutionMethod.pOST,
      body: executionBody,
    );

    print("Cloud Function Response Status: ${execution.status}");
    final image = jsonDecode(execution.responseBody);
    final result = await storageservice.urlToBytes(image['result']);
    return result;
  } catch (e) {
    throw Exception(
      'Appwrite pipeline function execution failed: ${e.toString()}',
    );
  }
}
