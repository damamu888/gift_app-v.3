import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gift_app/constants/routes.dart';
import 'package:gift_app/models/ModelProvider.dart';
import 'dart:async';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String nickname;
  List<Person> _persons = [];
  late StreamSubscription<QuerySnapshot<Person>> _subscription;

  Future<void> getNickname() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      for (final element in attributes) {
        if (element.userAttributeKey == CognitoUserAttributeKey.nickname) {
          nickname = element.value;
        }
      }
    } on AuthException catch (e) {
      safePrint(e);
    }
  }

  Future<void> signOutCurrentUser() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  Future<void> deletePerson(Person person) async {
    try {
      await Amplify.DataStore.delete(person);
    } catch (e) {
      safePrint(e);
    }
  }

  @override
  void initState() {
    _subscription = Amplify.DataStore.observeQuery(Person.classType).listen((
      QuerySnapshot<Person> snapshot,
    ) {
      setState(() {
        _persons = snapshot.items;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              leading: Center(
                child: Text(nickname),
              ),
              title: const Text('Home'),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: signOutCurrentUser,
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: _personList(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newPersonRoute);
              },
              child: const Icon(Icons.add),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: getNickname(),
    );
  }

  Widget _personList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _persons.length,
            itemBuilder: ((context, index) {
              return ListTile(
                title: Text(_persons[index].name),
                trailing: IconButton(
                  onPressed: () {
                    deletePerson(_persons[index]);
                  },
                  icon: const Icon(Icons.delete),
                ),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black38,
                    width: 1,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(giftListRoute, arguments: _persons[index]);
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
