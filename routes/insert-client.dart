import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../sqlConnection.dart';

Future<Response> onRequest(RequestContext context) async {
  // payload: { "tas": String, "clientId": String, "clientPassword": String, "propertyOf": String, "inUseBy": String }
  final request = context.request;
  final requestBody = await request.body();
  final decodeBody = jsonDecode(requestBody);
  final tas = decodeBody['tas'];
  final clientId = decodeBody['clientId'];
  final clientPassword = decodeBody['clientPassword'];
  final propertyOf = decodeBody['propertyOf'];
  final inUseBy = decodeBody['inUseBy'];

  if (tas == null || tas == '') {
    return Response.json(
        statusCode: 400,
        body: {'statusCode': 400, 'Error': 'La TAS es requerida'});
  }

  if (clientId == null || clientId == '') {
    return Response.json(
        statusCode: 400,
        body: {'code': 400, 'error': 'El ID del cliente es requerido'});
  }
  if (clientPassword == null || clientPassword == '') {
    return Response.json(
        statusCode: 400,
        body: {'code': 400, 'error': 'La contraseña del cliente es requerida'});
  }

  var dbConnection;
  try {
    dbConnection = await sqlConnection();
  } catch (e) {
    print(e);
    return Response.json(
        body: {"message": 'No se puede conectar a la DB', "error": e});
  }
  final tasDbStatement =
      await dbConnection.prepare('SELECT TAS from Clients where TAS = ?');

  final result = await tasDbStatement.execute([tas]);
  if (result.rows.toList().isNotEmpty) {
    return Response.json(
        statusCode: 400, body: {"message": "The email alredy exist"});
  }
  final statement = await dbConnection.prepare(
      'INSERT INTO Clients (TAS, CLIENT_ID, CLIENT_PASSWORD, PROPERTY_OF, IN_USE_BY) VALUES (?, ?, ?, ?, ?)');
  await statement.execute([tas, clientId, clientPassword, propertyOf, inUseBy]);

  return Response.json(
      body: {'message': 'El cliente se ha agregado', 'statusCode': 200});
}
