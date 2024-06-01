import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'prediksi_cuaca.dart';
import 'services/weather_service.dart';
import 'favorite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _weatherData = [];
  List<dynamic> _filteredWeatherData = [];
  bool _isLoading = true;
  String? _error;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
    _searchController.addListener(_filterWeatherData);
  }

  Future<void> _fetchWeatherData() async {
    try {
      final weatherService = WeatherService();
      final data = await weatherService.fetchWeatherData();
      setState(() {
        _weatherData = data;
        _filteredWeatherData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterWeatherData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredWeatherData = _weatherData.where((item) {
        final kota = item['kota'].toString().toLowerCase();
        return kota.contains(query);
      }).toList();
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // Dialog tidak bisa ditutup dengan tap di luar
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _logout(context); // Logout jika "Yes" dipilih
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/header.jpg',
              fit: BoxFit.cover,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              alignment: Alignment.center,
              child: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(
                    color: Colors.white), // Set icon color to white
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'WeatherVision',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28, // Main title text size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Your Weather Future Unveiled',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Slogan text size
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/header.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'WeatherVision',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ), // Space between title and slogan
                        Text(
                          'Your Weather Future Unveiled',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text('My Favorite City'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FavoritePage()), // Ganti ke FavoritePage
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Setting'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                _confirmLogout(context);
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(28.0, 24.0, 28.0, 12.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search City',
                          labelStyle: TextStyle(
                            color: Colors.grey[700], // Warna label text
                            fontSize: 18.0, // Ukuran label text
                            fontWeight: FontWeight.w400, // Ketebalan label text
                          ),
                          hintText: 'Enter city name',
                          hintStyle: TextStyle(
                            color: Colors.grey[500], // Warna hint text
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Membuat border dengan radius
                            borderSide: BorderSide(
                              color: Colors.orange, // Warna border
                              width: 2.0, // Lebar border
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors
                                  .orange, // Warna border ketika textfield aktif
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors
                                  .orange, // Warna border ketika textfield fokus
                              width: 2.0,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[700], // Warna icon search
                          ),
                          filled: true,
                          fillColor: Colors.white, // Warna background textfield
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
                        ),
                        style: TextStyle(
                          color: Colors.black, // Warna teks yang dimasukkan
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                        itemCount: _filteredWeatherData.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(_filteredWeatherData[index]['kota']),
                              subtitle:
                                  Text(_filteredWeatherData[index]['propinsi']),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  String id = _filteredWeatherData[index]
                                      ['id']; // ID dari item
                                  String kotaName = _filteredWeatherData[index]
                                      ['kota']; // Nama kota
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PrediksiCuacaPage(id, kotaName),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.orange, // Warna background tombol
                                ),
                                child: Text(
                                  'Detail',
                                  style: TextStyle(
                                      color: Colors.white), // Warna teks tombol
                                ),
                              ),
                              onTap: () {
                                // Handle item tap if necessary
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
