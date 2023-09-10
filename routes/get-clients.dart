import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../sqlConnection.dart';

Future<Response> onRequest(RequestContext context) async {
  final request = context.request;
  final requestBody = await request.body();
  final decodeBody = jsonDecode(requestBody);

  var dbConnection;
  try {
    dbConnection = await sqlConnection();
  } catch (e) {
    print(e);
    return Response.json(
        body: {"message": 'No se puede conectar a la DB', "error": e});
  }
  final idQueryStatement = await dbConnection.prepare('SELECT * from Clients');
  final result = await idQueryStatement.execute([]);
  final resultList = result.rows.toList();
  final responseData = resultList.map((e) => e.assoc()).toList();
  return Response.json(statusCode: 200, body: {"data": responseData});
}
