import 'dart:typed_data';

class AppModel{
  final String title;
  final String package;
  final Uint8List icon;
  final String apkFilePath;
  bool isSelected;

  AppModel({
    required this.title,
    required this.package,
    required this.icon,
    required this.apkFilePath,
    required this.isSelected,
  });
}