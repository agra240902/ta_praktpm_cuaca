import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tokokripto/login_page.dart';
import 'user_model.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _namaController = TextEditingController(); //kontroler untuk mengelola teks dalam field
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _register() async {
    final box = await Hive.openBox<User>('users');
    final user = User(
      nama: _namaController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );
    await box.add(user);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registrasi Berhasil'),
        content: Text('Akun Anda telah berhasil dibuat.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding:
            EdgeInsets.fromLTRB(42.0, 70.0, 42.0, 0.0), // Padding keseluruhan
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/logoo.png',
              height: 250,
              width: 250,
            ),
            SizedBox(height: 24), // Padding antara elemen
            Text(
              'Register Page',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start, // Teks rata tengah
            ),
            SizedBox(height: 0), // Padding antara elemen
            Text(
              'Your weather future unveiled',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.start, // Teks rata tengah
            ),
            SizedBox(height: 24), // Padding antara elemen
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0), // Padding form
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _namaController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      labelText: 'Name',
                      hintText: 'Enter Name',
                    ),
                  ),
                  SizedBox(height: 16), // Padding antara elemen
                  TextField(
                    controller: _usernameController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      labelText: 'Username',
                      hintText: 'Enter Username',
                    ),
                  ),
                  SizedBox(height: 16), // Padding antara elemen
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      labelText: 'Password',
                      hintText: 'Enter Password',
                    ),
                  ),
                  SizedBox(height: 24), // Padding antara elemen
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Daftar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 24), // Padding antara elemen
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Sudah punya akun? Login sekarang!',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
