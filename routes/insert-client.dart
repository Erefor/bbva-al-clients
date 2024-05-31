import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import '../sqlConnection.dart';

Future<Response> onRequest(RequestContext context) async {
  final requestBody = jsonDecode(await context.request.body());
  bool needData = false;
  requestBody.forEach((key, value) {
    if (value == '' || value == null){
      needData = true;
    }
  });
  if (needData){
    return Response.json(
      statusCode: 400,
      body: {
      'message': 'Please fill all the fields',
    },);
  }

  final tas = requestBody['tas'];
  final clientId = requestBody['clientId'];
  final serial = requestBody['serial'];
  final account = requestBody['account'];
  final password = requestBody['password'];
  final clientType = requestBody['clientType'];
  final segment = requestBody['segment'];
  final clientOwner = requestBody['clientOwner'];
  final useBy = requestBody['useBy'];
  final readerId = requestBody['readerId'];
  final phoneNumber = requestBody['phoneNumber'];
  final phoneNumberOwner = requestBody['phoneNumberOwner'];

  try {
    final connection = await sqlConnection();
    final statement = await connection.prepare('INSERT INTO Clients (tas, clientId, serial, account, password, clientType, segment, clientOwner, useBy, readerId, phoneNumber, phoneNumberOwner) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');
    await statement.execute([tas, clientId, serial, account, password, clientType, segment, clientOwner, useBy, readerId, phoneNumber, phoneNumberOwner]);
    return Response.json(
      statusCode: 201,
      body: {
        'message': 'Client inserted successfully',
        'extra': 'Pinche chismoso'
      },);
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {
      'message': 'An error occurred',
      'error': e.toString(),
    },);
  }
}
