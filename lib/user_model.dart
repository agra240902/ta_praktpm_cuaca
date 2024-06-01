import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String nama;

  @HiveField(1)
  String username;

  @HiveField(2)
  String password;

  User({required this.nama, required this.username, required this.password});
}
