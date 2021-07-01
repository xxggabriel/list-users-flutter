import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final GlobalKey<FormState> _form = new GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  void _loadFormData(user) {
    if (user != null) {
      _formData['id'] = user.id;
      _formData['name'] = user.name;
      _formData['email'] = user.email;
      _formData['avatarUrl'] = user.avatarUrl;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = ModalRoute.of(context)?.settings.arguments;
    _loadFormData(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulário de usuário"),
        actions: [
          IconButton(
            onPressed: () {
              final isValid = _form.currentState?.validate() ?? false;

              if (isValid) {
                _form.currentState?.save();
                Provider.of<Users>(context, listen: false).put(
                  User(
                    id: _formData['id'] ?? '',
                    name: _formData['name'] ?? '',
                    email: _formData['email'] ?? '',
                    avatarUrl: _formData['avatarUrl'] ?? '',
                  ),
                );

                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe um valor';
                  }

                  if (value.trim().length <= 3) {
                    return 'Nome é muito pequeno. No mínimo 3 letras.';
                  }

                  return null;
                },
                initialValue: _formData['name'],
                onSaved: (name) => _formData['name'] = name ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'E-mail',
                ),
                initialValue: _formData['email'],
                onSaved: (email) => _formData['email'] = email ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'URL do Avatar',
                ),
                initialValue: _formData['avatarUrl'],
                onSaved: (url) => _formData['avatarUrl'] = url ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
