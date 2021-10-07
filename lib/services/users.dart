import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  String name;
  String picture;

  User({required this.name, required this.picture});
}

class Users {
  static Future<List<User>> lista() async {
    List<User> users = [];
    var response = await http.get(
      Uri.parse('https://randomuser.me/api?results=40&nat=BR&inc=name,picture'),
    );
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      for (var userJson in responseJson['results']) {
        users.add(
          User(
            name: "${userJson['name']['first']} ${userJson['name']['last']}",
            picture: userJson['picture']['thumbnail'],
          ),
        );
      }
    }
    return users;
  }
}
