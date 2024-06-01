import 'package:mysql_client/mysql_client.dart';

Future sqlConnection() async {
  try {
    final connection = await MySQLConnection.createConnection(
        host: 'localhost',
        port: 33060,
        userName: 'root',
        password: 'secret',
        databaseName: 'bbva_all_clients');
    await connection.connect();
    return connection;
  } catch (e) {
    return e;
  }
}
