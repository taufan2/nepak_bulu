import 'package:cloud_firestore/cloud_firestore.dart';

class DontMatchWithPlayerModel {
  final String name;
  final DocumentReference<Map<String, dynamic>> docRef;
  final bool enabled;

  DontMatchWithPlayerModel({
    required this.name,
    required this.docRef,
    required this.enabled,
  });

  factory DontMatchWithPlayerModel.fromFirestore(Map<String, dynamic> json) {
    final player = DontMatchWithPlayerModel(
      docRef: json['ref'],
      name: json['name'],
      enabled: json['enabled'],
    );
    return player;
  }
}
