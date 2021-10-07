import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hide_appbar_scroll/services/users.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool showFAB = true;

  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  )..forward();

  late final _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _animation.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, __) => [
          const SliverAppBar(
            title: Text('App Bar'),
            snap: true,
            floating: true,
          ),
        ],
        body: FutureBuilder(
          future: Users.lista(),
          builder: (context, AsyncSnapshot<List<User>> snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            return NotificationListener<UserScrollNotification>(
              onNotification: (scroll) {
                if (scroll.direction == ScrollDirection.reverse && showFAB) {
                  _controller.reverse();
                  showFAB = false;
                } else if (scroll.direction == ScrollDirection.forward &&
                    !showFAB) {
                  _controller.forward();
                  showFAB = true;
                }
                return true;
              },
              child: ListView.separated(
                itemCount: 40,
                itemBuilder: (BuildContext context, int index) {
                  final User user = snap.data![index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.picture),
                    ),
                    title: Text(user.name),
                  );
                },
                separatorBuilder: (__, _) => const Divider(),
              ),
            );
          },
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _animation,
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
