import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gift_app/models/ModelProvider.dart';

class NewGiftView extends StatefulWidget {
  const NewGiftView({super.key});

  @override
  State<NewGiftView> createState() => _NewGiftViewState();
}

class _NewGiftViewState extends State<NewGiftView> {
  late TextEditingController _nameController;
  late final Person _person;

  Future<void> saveGift(String name) async {
    final newGift = Gift(
      name: name,
      isSelected: false,
      receiver: _person,
    );
    try {
      await Amplify.DataStore.save(newGift);
    } catch (e) {
      safePrint('Fehler beim speichern: $e');
    }
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _person = ModalRoute.of(context)!.settings.arguments as Person;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geschenk Hinzufügen'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          _icon(),
          const SizedBox(
            height: 40,
          ),
          _description(),
          const SizedBox(
            height: 40,
          ),
          _textField(),
          const SizedBox(
            height: 50,
          ),
          _button(),
        ],
      ),
    );
  }

  Widget _icon() {
    return Center(
      child: Image.asset(
        "lib/assets/present.png",
        scale: 1.5,
      ),
    );
  }

  Widget _description() {
    return const Center(
      child: Text(
        "Trage eine neue Geschenkidee ein!",
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _textField() {
    return Container(
      margin: const EdgeInsetsDirectional.all(8),
      child: TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          hintText: 'Geschenk',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _button() {
    return ElevatedButton(
      onPressed: () async {
        if (_nameController.text.isNotEmpty) {
          saveGift(_nameController.text);
        }
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
      child: const Text('Hinzufügen'),
    );
  }
}
