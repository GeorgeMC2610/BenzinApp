import 'package:benzinapp/services/managers/user_manager.dart';
import 'package:benzinapp/views/shared/buttons/persistent_add_or_edit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  String? emailError, usernameError;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final currentUser = UserManager().currentUser;
    if (currentUser != null) {
      emailController.text = currentUser.email;
      usernameController.text = currentUser.username;
    }
  }

  void _saveChanges() async {
    setState(() {
      emailError = null;
      usernameError = null;
      isLoading = true;
    });
    final result = await UserManager().update(usernameController.text);
    setState(() {
      isLoading = false;
    });
    if (result != UserPayloadStatus.confirmedOk) {
      setState(() {
        usernameError = translate('usernameAlreadyTaken');
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(translate('editAccount')), 
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        PersistentAddOrEditButton(
          onPressed: _saveChanges,
          isEditing: true,
          isLoading: isLoading,
        )
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: false, // Locked for now
                decoration: InputDecoration(
                  labelText: translate('email'),
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                keyboardType: TextInputType.text,
                enabled: !isLoading,
                maxLength: 16,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  errorMaxLines: 3,
                  errorText: usernameError,
                  labelText: translate('username'),
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
