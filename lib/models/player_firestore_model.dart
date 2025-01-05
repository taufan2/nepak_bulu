import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nepak_bulu_2/models/dont_match_with_player_model.dart';

class PlayerFirestoreModel {
  String name;
  bool presence;
  bool active;
  bool readonly;
  bool lowPriority;
  DateTime createdAt;
  List<DontMatchWithPlayerModel> dontMatchWith;

  DocumentReference<Map<String, dynamic>>? _ref;
  String? _id;

  PlayerFirestoreModel({
    required this.name,
    required this.presence,
    required this.active,
    required this.readonly,
    required this.lowPriority,
    required this.createdAt,
    required this.dontMatchWith,
  });

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "presence": presence,
      "active": active,
      "readonly": readonly,
      "lowPriority": lowPriority,
      "createdAt": Timestamp.fromDate(createdAt),
      "dontMatchWith": dontMatchWith.map(
        (e) {
          return {
            "ref": e.docRef,
            "name": e.name,
            "enabled": e.enabled,
          };
        },
      ),
    };
  }

  factory PlayerFirestoreModel.fromFirestore(Map<String, dynamic> json,
      DocumentReference<Map<String, dynamic>> reference) {
    final dontMatch = json['dontMatchWith'] != null
        ? (json['dontMatchWith'] as List<dynamic>).map(
            (e) {
              return DontMatchWithPlayerModel.fromFirestore(e);
            },
          ).toList()
        : <DontMatchWithPlayerModel>[];

    final player = PlayerFirestoreModel(
      name: json["name"],
      presence: json["presence"],
      active: json["active"],
      lowPriority: json["lowPriority"] ?? false,
      readonly: json["readonly"] ?? false,
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      dontMatchWith: dontMatch,
    );

    player.setId(reference.id);
    player.setRef(reference);

    return player;
  }

  void setId(String id) {
    _id = id;
  }

  String? get id => _id;

  void setRef(DocumentReference<Map<String, dynamic>> value) {
    _ref = value;
  }

  DocumentReference<Map<String, dynamic>>? get documentRef => _ref;
}
