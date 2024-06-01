import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Model untuk kota favorit
class KotaFavorit {
  final String id;
  final String kotaName;

  KotaFavorit(this.id, this.kotaName);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kotaName': kotaName,
    };
  }

  factory KotaFavorit.fromJson(Map<String, dynamic> json) {
    return KotaFavorit(json['id'], json['kotaName']);
  }
}

class PrediksiCuacaPage extends StatefulWidget {
  final String id;
  final String kotaName;

  PrediksiCuacaPage(this.id, this.kotaName);

  @override
  _PrediksiCuacaPageState createState() => _PrediksiCuacaPageState();
}

class _PrediksiCuacaPageState extends State<PrediksiCuacaPage> {
  List<dynamic> _weatherPrediction = [];
  bool _isLoading = true;
  List<KotaFavorit> _kotaFavoritList = [];
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchWeatherPrediction();
    _loadFavoriteCities();
  }

  Future<void> _fetchWeatherPrediction() async {
    final response = await http.get(Uri.parse(
        'https://ibnux.github.io/BMKG-importer/cuaca/${widget.id}.json'));

    if (response.statusCode == 200) {
      setState(() {
        _weatherPrediction = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load weather prediction data');
    }
  }

  _saveFavoriteCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteCities =
        _kotaFavoritList.map((kota) => jsonEncode(kota.toJson())).toList();
    await prefs.setStringList('favoriteCities', favoriteCities);
  }

  _loadFavoriteCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteCities = prefs.getStringList('favoriteCities') ?? [];
    setState(() {
      _kotaFavoritList = favoriteCities
          .map((city) => KotaFavorit.fromJson(jsonDecode(city)))
          .toList();
      _isFavorite = _kotaFavoritList.any((kota) => kota.id == widget.id);
    });
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
                iconTheme: IconThemeData(color: Colors.white),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.kotaName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(24.0, 4.0, 24.0, 0.0),
              itemCount: _weatherPrediction.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            'Date: ${_weatherPrediction[index]['jamCuaca']}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Cuaca: ${_weatherPrediction[index]['cuaca']}'),
                              Text(
                                  'Temperature: ${_weatherPrediction[index]['tempC']}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isFavorite = !_isFavorite;
            if (_isFavorite) {
              _kotaFavoritList.add(KotaFavorit(widget.id, widget.kotaName));
            } else {
              _kotaFavoritList.removeWhere((kota) => kota.id == widget.id);
            }
          });
          _saveFavoriteCities(); // Simpan perubahan ke SharedPreferences
          final snackBar = SnackBar(
            content: Text(_isFavorite
                ? 'Berhasil menambahkan ke favorit'
                : 'Berhasil menghapus favorit'),
            backgroundColor: _isFavorite ? Colors.green : Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Icon(
          Icons.favorite,
          color: _isFavorite ? Colors.red : null,
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
