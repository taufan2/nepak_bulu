import 'package:cloud_firestore/cloud_firestore.dart';

class PairModel {
  final DateTime createdAt;
  final List<PlayerPair> pairs;
  final String? noTeam;
  final DocumentReference<Map<String, dynamic>> docRef;

  PairModel({
    required this.createdAt,
    required this.pairs,
    required this.docRef,
    this.noTeam,
  });

  factory PairModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PairModel(
      docRef: doc.reference,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      pairs: (data['pairs'] as List)
          .map((pair) => PlayerPair.fromMap(pair as Map<String, dynamic>))
          .toList(),
      noTeam: data['noTeam'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': Timestamp.fromDate(createdAt),
      'pairs': pairs.map((pair) => pair.toMap()).toList(),
      'noTeam': noTeam,
    };
  }

  static CollectionReference<PairModel> withCollectionConverter(
      CollectionReference collectionReference) {
    return collectionReference.withConverter<PairModel>(
      fromFirestore: (snapshot, _) {
        try {
          return PairModel.fromFirestore(snapshot);
        } catch (e) {
          rethrow;
        }
      },
      toFirestore: (pairModel, _) => pairModel.toMap(),
    );
  }
}

class PlayerPair {
  final Player player1;
  final Player player2;

  PlayerPair({
    required this.player1,
    required this.player2,
  });

  factory PlayerPair.fromMap(Map<String, dynamic> map) {
    return PlayerPair(
      player1: Player.fromMap(map['player1'] as Map<String, dynamic>),
      player2: Player.fromMap(map['player2'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'player1': player1.toMap(),
      'player2': player2.toMap(),
    };
  }
}

class Player {
  final String name;
  final DocumentReference docRef;

  Player({
    required this.name,
    required this.docRef,
  });

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'] as String,
      docRef: map['docRef'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'docRef': docRef,
    };
  }
}
