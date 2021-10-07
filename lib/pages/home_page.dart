import 'package:flutter/material.dart';
import 'package:flutter_hide_appbar_scroll/services/users.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Bar'),
      ),
      body: FutureBuilder(
        future: Users.lista(),
        builder: (context, AsyncSnapshot<List<User>> snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            itemCount: 40,
            itemBuilder: (BuildContext context, int index) {
              final User user = snap.data![index];
              return ListTile(
                leading:
                    CircleAvatar(backgroundImage: NetworkImage(user.picture)),
                title: Text(user.name),
              );
            },
            separatorBuilder: (__, _) => const Divider(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
      ),
    );
  }
}
