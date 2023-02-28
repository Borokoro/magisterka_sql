import 'package:mysql1/mysql1.dart';
import 'package:magisterka_sql/models/users.dart';
class MySQL{

  late final MySqlConnection conn;

  Future<void> establishConnection() async{
    conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        db: 'magisterka',
        password: 'secret'));
  }

  Future<void> createTable() async{
    await conn.query('CREATE TABLE users (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, name varchar(255), surname varchar(255), age int, email varchar(255)');
  }

  Future<void> setUserData(String name, String surname, int age, String email) async{
    await conn.query('insert into users (name, surname, age, email) values (?, ?, ?, ?)',
      [name, surname, age, email]);
  }

  Future<List<User>> getAllUsers() async{
    final List<User> users=[];
    var result=await conn.query('select * from users');
    for(var row in result){
      users.add(
        User(
            name: row[0],
            surname: row[1],
            age: row[2]),
      );
    }
    return users;
  }

  Future<void> deleteRecords() async{
    await conn.query('truncate users');
  }
}