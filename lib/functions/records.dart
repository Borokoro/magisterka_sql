import 'package:magisterka_sql/mySQL/mySQL.dart';
import 'package:magisterka_sql/models/users.dart';
class Records{
  final MySQL mySql;
  Records({required this.mySql});
  Future<void> addRecords() async{
    for(int i=0; i<1000; i++){
      await mySql.setUserData('Marek', 'Cichon', 23, 'asdf@gmail.com');
    }
  }
  Future<void> getRecords() async{
    List<User> users=[];
    users=await mySql.getAllUsers();
  }

  Future<void> deleteRecords() async{
    await mySql.deleteRecords();
  }
}