import 'package:flutter/material.dart';
import 'prediksi_cuaca.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<KotaFavorit> _kotaFavoritList = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteCities();
  }

  _loadFavoriteCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteCities = prefs.getStringList('favoriteCities') ?? [];
    setState(() {
      _kotaFavoritList = favoriteCities
          .map((city) => KotaFavorit.fromJson(jsonDecode(city)))
          .toList();
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
                        'Favorite Cities',
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
        body: _kotaFavoritList.isEmpty
            ? Center(
                child: Text('No favorite cities yet'),
              )
            : ListView.builder(
                padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0,
                    0.0), // Tambahkan padding untuk ListView.builder
                itemCount: _kotaFavoritList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        _kotaFavoritList[index].kotaName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('ID: ${_kotaFavoritList[index].id}'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .orange, // Atur latar belakang tombol menjadi orange
                        ),
                        onPressed: () {
                          String id = _kotaFavoritList[index].id;
                          String kotaName = _kotaFavoritList[index].kotaName;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PrediksiCuacaPage(id, kotaName),
                            ),
                          );
                        },
                        child: Text(
                          "See Detail",
                          style: TextStyle(color: Colors.white),
                        ), // Icon panah berwarna putih
                      ),
                    ),
                  );
                },
              ));
  }
}
