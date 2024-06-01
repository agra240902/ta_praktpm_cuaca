import 'package:flutter/material.dart'; 
import 'package:hive_flutter/hive_flutter.dart'; 
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'login_page.dart';
import 'user_model.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Hive.initFlutter(); 
  Hive.registerAdapter(UserAdapter()); 
  await Hive.openBox<User>('users'); 

  // Periksa status login saat aplikasi dimulai
  final isLoggedIn = await checkLoginStatus();

  runApp(MaterialApp(
    title: 'Login App',
    home: isLoggedIn ? HomePage() : LoginPage(),
  ));
}

// Fungsi untuk memeriksa status login
Future<bool> checkLoginStatus() async {
  final box = await Hive.openBox<User>('users');
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Jika ada data user di Hive dan status login true, kembalikan true
  return box.isNotEmpty && isLoggedIn;
}
