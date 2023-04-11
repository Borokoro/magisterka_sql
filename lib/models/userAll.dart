
class UserAll{
  final String name;
  final String surname;
  final int age;
  final String email;
  final int money;
  final Map<String, dynamic> address;
  final List<dynamic> basket;
  final List<dynamic> transactionHistory;
  final List<dynamic> listedItem;
  UserAll(
      {required this.name,
        required this.surname,
        required this.age,
        required this.email,
        required this.money,
        required this.address,
        required this.basket,
        required this.transactionHistory,
        required this.listedItem
      });
}