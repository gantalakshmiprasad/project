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
    final execution = await authservices.function.createExecution(
      functionId: ApiConfig().functionid,
      method: ExecutionMethod.pOST,

      body: '{"prompt":"$promptText"}',
    );
    print(execution.responseBody);
    final image = jsonDecode(execution.responseBody);
    final result = await storageservice.urlToBytes(image['result']);
    print(result);
    return result;
  } catch (e) {
    throw Exception(e.toString());
  }
}
