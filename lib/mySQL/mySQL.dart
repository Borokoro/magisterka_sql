import 'dart:math';

import 'package:mysql1/mysql1.dart';
import 'package:magisterka_sql/models/users.dart';

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
    conn = await MySqlConnection.connect(ConnectionSettings(
        host: '10.0.2.2',
        port: 3306,
        user: 'user',
        db: 'magisterka',
        password: 'user'));
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
      for (int j = randomNumber(); j < 5; j++) {
        await conn.query(
            'insert into product (name, price, FK_transaction_historyID) values (?, ?, ?)',
            [productTransaction[j], priceTransaction[j], i+id*5]);
      }
    }
  }

  Future<List<User>> getAllUsers() async {
    final List<User> users = [];
    var result = await conn.query('select * from users');
    for (var row in result) {
      users.add(
        User(name: row[0], surname: row[1], age: row[2]),
      );
    }
    return users;
  }

  Future<void> deleteRecords() async {
    await conn.query('truncate users');
  }
}
