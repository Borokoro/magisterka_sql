import 'dart:math';

import 'package:magisterka_sql/mySQL/mySQL.dart';
import 'package:magisterka_sql/models/userAll.dart';

import '../models/user_selected.dart';

class Records {
  final MySQL mySql;
  Records({required this.mySql});
  final List<String> name = [
    'Marek',
    'Jan',
    'Jakub',
    'Michał',
    'Piotr',
    'Dorota',
    'Anna',
    'Kazimierz',
    'Damian',
    'Aleksander',
    'Adam',
    'Mariusz',
    'Ewa',
    'Wiktoria',
    'Martyna',
    'Katarzyna',
    'Aleksandra',
    'Sebastian',
    'Alina',
    'Kacper',
  ];

  final List<String> surname = [
    'Nowak',
    'Kowalski',
    'Wiśniewski',
    'Wójcik',
    'Kowalczyk',
    'Kamiński',
    'Lewandowski',
    'Zieliński',
    'Szymański',
    'Woźniak',
    'Dąbrowski',
    'Kozłowki',
    'Mazur',
    'Jankowski',
    'Kwiatkowska',
    'Wojciechwoski',
    'Krawczyk',
    'Kaczmarek',
    'Piotrowski',
    'Grabowski',
  ];

  final List<String> city = [
    'Amsterdam',
    'Berlin',
    'Madryt',
    'Londyn',
    'Paryż',
    'Warszawa',
    'Budapeszt',
    'Praga',
    'Bratysława',
    'Wilno',
    'Ateny',
    'Lizbona',
    'Ryga',
    'Wiedeń',
    'Bruksela',
    'Kopenhaga',
    'Rzym',
    'Dublin',
    'Oslo',
    'Sztokholm'
  ];

  final List<String> country = [
    'Hiszpania',
    'Portugalia',
    'Malta',
    'Grecja',
    'Cypr',
    'Łotwa',
    'Litwa',
    'Estonia',
    'Szwecja',
    'Finlandia',
    'Węgry',
    'Polska',
    'Czechy',
    'Austria',
    'Niemcy',
    'Belgia',
    'Holandia',
    'Dania',
    'Włochy',
    'Francja',
  ];

  final List<String> products = [
    'Rower',
    'Piła',
    'Hulajnoga',
    'Kosz',
    'Bluza',
    'Listwa',
    'Kabel',
    'Monitor',
    'Lampa',
    'Kaktus',
    'Łóżko',
    'Kanapa',
    'Biurko',
    'Ładowarka',
    'Latarka',
    'Książka',
    'Śłuchawaki',
    'Mikrofon',
    'Głośniki',
    'Pokrowiec',
  ];

  final random = Random();

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  String randomString() {
    return List.generate(20, (index) => _chars[random.nextInt(_chars.length)])
        .join();
  }

  int randomAge() {
    return 12 + random.nextInt(100 - 12);
  }

  int randomNumber() {
    return 0 + random.nextInt(20);
  }

  int randomValue() {
    return 1 + random.nextInt(100);
  }

  List<String> randomProducts() {
    List<String> productsList = <String>[];
    for (int i = 0; i < 5; i++) {
      productsList.add(products[randomNumber()]);
    }
    return productsList;
  }

  List<int> randomPrice() {
    List<int> price = <int>[];
    for (int i = 0; i < 10; i++) {
      price.add(randomValue());
    }
    return price;
  }

  Future<void> addRecords() async {
    await mySql.createTable();
    for (int i = 0; i < 5; i++) {
      await mySql.setUserData(i,
          name[randomNumber()],
          surname[randomNumber()],
          randomAge(),
          '${randomString()}@gmail.com',
          randomNumber(),
          country[randomNumber()],
          city[randomNumber()],
          randomProducts(),
          randomPrice(),
          randomProducts(),
          randomPrice(),
          randomProducts(),
          randomPrice());
    }
  }

  Future<void> getRecords() async {
    List<UserAll> users = [];
    users = await mySql.getAllUsers();
  }

  Future<void> getRecordsSelected() async {
    List<UserSelected> users = [];
    users = await mySql.getAllUsersSelected();
  }

  Future<void> updateRecords() async {
    await mySql.updateRecords();
  }

  Future<void> deleteRecords() async {
    await mySql.deleteRecords();
  }
}
