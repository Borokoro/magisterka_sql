import 'dart:math';

import 'package:mysql1/mysql1.dart';
import 'package:magisterka_sql/models/userAll.dart';

import '../models/user_selected.dart';

class MySQL {
  late final MySqlConnection conn;
  final random = Random();
  int randomNumber() {
    return 0 + random.nextInt(4);
  }

  int randomTwo() {
    return 0 + random.nextInt(2);
  }

  final List<String> transactionType = ['bought', 'sold'];

  Future<void> establishConnection() async {
    /*conn = await MySqlConnection.connect(ConnectionSettings(
        host: '10.0.2.2',
        port: 3306,
        user: 'user',
        db: 'magisterka',
        password: 'user'));*/

    conn = await MySqlConnection.connect(ConnectionSettings(
        host: '34.116.209.150',
        port: 3306,
        user: 'root',
        db: 'magisterka',
        password: 'magisterka'));


    //hasło do cloud store to magisterka

    /*conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'sql7.freemysqlhosting.net',
        port: 3306,
        user: 'sql7612277',
        db: 'sql7612277',
        password: 'mRL548KA8D'));*/


    print('done');
  }

  Future<void> createTable() async {
    await conn.query(
        'CREATE TABLE users (PK_usersID INT PRIMARY KEY, name varchar(255), surname varchar(255), age INT, email varchar(255), money INT)');
    await conn.query(
        'CREATE TABLE address (PK_addressID INT PRIMARY KEY,  country varchar(255), city varchar(255), FK_usersID INT UNIQUE, FOREIGN KEY (FK_usersID) REFERENCES users(PK_usersID))');
    await conn.query(
        'CREATE TABLE basket_products (PK_basket_productsID INT PRIMARY KEY AUTO_INCREMENT,  name varchar(255), price int, FK_usersID INT, FOREIGN KEY (FK_usersID) REFERENCES users(PK_usersID))');
    await conn.query(
        'CREATE TABLE listed_items (PK_listed_itemsID INT PRIMARY KEY AUTO_INCREMENT, name varchar(255), price int, FK_usersID INT, FOREIGN KEY (FK_usersID) REFERENCES users(PK_usersID))');
    await conn.query(
        'CREATE TABLE transaction_history (PK_transaction_historyID INT PRIMARY KEY AUTO_INCREMENT, date varchar(255), transaction_type varchar(255), FK_usersID INT, FOREIGN KEY (FK_usersID) REFERENCES users(PK_usersID))');
    await conn.query(
        'CREATE TABLE product (PK_productID INT PRIMARY KEY AUTO_INCREMENT, name varchar(255), price int, FK_transaction_historyID INT, FOREIGN KEY (FK_transaction_historyID) REFERENCES transaction_history(PK_transaction_historyID))');
  }

  Future<void> setUserData(
      int id,
      String name,
      String surname,
      int age,
      String email,
      int money,
      String country,
      String city,
      List<String> productBasket,
      List<int> priceBasket,
      List<String> productListed,
      List<int> priceListed,
      List<String> productTransaction,
      List<int> priceTransaction) async {
    await conn.query(
        'insert into users (PK_usersID, name, surname, age, email, money) values (?, ?, ?, ?, ?, ?)',
        [id, name, surname, age, email, money]);
    for (int i = 0; i < productBasket.length; i++) {
      await conn.query(
          'insert into basket_products (name, price, FK_usersID) values (?, ?, ?)',
          [productBasket[i], priceBasket[i], id]);
    }
    await conn.query(
        'insert into address (PK_addressID, country, city, FK_usersID) values (?, ?, ?, ?)',
        [id, country, city, id]);

    for (int i = 0; i < productListed.length; i++) {
      await conn.query(
          'insert into listed_items (name, price, FK_usersID) values (?, ?, ?)',
          [productListed[i], priceListed[i], id]);
    }
    DateTime dateTime = DateTime.now();

    for (int i = 1; i <= productTransaction.length; i++) {
      await conn.query(
          'insert into transaction_history (date, transaction_type,FK_usersID) values (?, ?, ?)',
          [dateTime.toString(), transactionType[randomTwo()], id]);
      for (int j = 0; j < 5; j++) {
        await conn.query(
            'insert into product (name, price, FK_transaction_historyID) values (?, ?, ?)',
            [productTransaction[j], priceTransaction[j], i+id*5]);
      }
    }
  }

  Future<List<UserAll>> getAllUsers() async {
    final List<UserAll> users = [];
    List<Map<String, String>> basket = [];
    List<Map<String, String>> product = [];
    List<Map<String, dynamic>> transactionHistory = [];
    List<Map<String, String>> listedItem = [];

    var result = await conn.query('SELECT u.PK_usersID, u.name, u.surname, u.age, u.email, u.money,'
        ' a.country, a.city from users u inner join address a on u.PK_usersID=a.FK_usersID');
    for (var row in result) {
      var resultBasket = await conn.query('SELECT bp.name, bp.price from users u'
          ' inner join basket_products bp on u.PK_usersID=bp.FK_usersID where u.PK_usersID=${row[0].toString()}');
      for(var rowBasket in resultBasket){
        basket.add({rowBasket[0].toString(): rowBasket[1].toString()});
      }
      var resultListed = await conn.query('SELECT li.name, li.price from users u'
          ' inner join listed_items li on u.PK_usersID=li.FK_usersID where u.PK_usersID=${row[0].toString()}');
      for(var rowListed in resultListed){
        listedItem.add({rowListed[0].toString(): rowListed[1].toString()});
      }
      var resultTransaction = await conn.query('SELECT th.PK_transaction_historyID, th.date, th.transaction_type from users u'
          ' inner join transaction_history th on u.PK_usersID=th.FK_usersID where u.PK_usersID=${row[0].toString()}');
      for(var rowTransaction in resultTransaction){
        var resultProduct = await conn.query('SELECT p.name, p.price from transaction_history th'
            ' inner join product p on th.PK_transaction_historyID=p.FK_transaction_historyID'
            ' where th.PK_transaction_historyID=${rowTransaction[0].toString()}');
        for(var rowProduct in resultProduct){
          product.add({rowProduct[0].toString(): rowProduct[1].toString()});
        }
        transactionHistory.add({
          'date': rowTransaction[1],
          'transaction type': rowTransaction[2],
          'product': product
        });
      }
      users.add(
        UserAll(
          name: row[1].toString(),
          surname: row[2].toString(),
          age: row[3],
          email: row[4].toString(),
          money: row[5],
          address: {row[6].toString(): row[7].toString()},
          basket: basket,
          listedItem: listedItem,
          transactionHistory: transactionHistory,
        ),
      );
      basket = [];
      product = [];
      transactionHistory = [];
      listedItem = [];
    }
    return users;
  }

  Future<List<UserSelected>> getAllUsersSelected() async {
    final List<UserSelected> users = [];
    List<Map<String, int>> listedItem = [];
    int whichId=0;
    var result=await conn.query('SELECT u.PK_usersID, li.name, li.price FROM listed_items li inner join'
        ' users u on u.PK_usersID=li.FK_usersID inner join address a on u.PK_usersID=a.FK_usersID'
        ' inner join basket_products bp on u.PK_usersID=bp.FK_usersID'
        ' where a.country="Polska" and bp.name="Kosz"');
    for(var row in result){
      if(listedItem.isEmpty){
        whichId=row[0];
      }
      if(whichId!=row[0]){
        users.add(
          UserSelected(
            listedItem: listedItem,
          ),
        );
        listedItem=[];
        whichId=row[0];
      }
      listedItem.add({row[1].toString():row[2]});
    }
    users.add(
      UserSelected(
        listedItem: listedItem,
      ),
    );
    return users;
  }

  Future<void> updateRecords() async{
    await conn.query('UPDATE address SET city="Warszawa" WHERE country="Polska"');
  }

  Future<void> deleteRecords() async {
    await conn.query('SET FOREIGN_KEY_CHECKS = 0');
    await conn.query('truncate address');
    await conn.query('truncate product');
    await conn.query('truncate basket_products');
    await conn.query('truncate listed_items');
    await conn.query('truncate transaction_history');
    await conn.query('truncate users');
    await conn.query('SET FOREIGN_KEY_CHECKS = 1');
    await conn.query('drop table address');
    await conn.query('drop table product');
    await conn.query('drop table basket_products');
    await conn.query('drop table listed_items');
    await conn.query('drop table transaction_history');
    await conn.query('drop table users');
  }
}
