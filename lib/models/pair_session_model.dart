import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nepak_bulu_2/dataSources/firestore_collections.dart';

class PairSessionModel {
  final String name;
  final DateTime createdAt;
  final DocumentReference<Map<String, dynamic>> docRef;

  PairSessionModel({
    required this.name,
    required this.createdAt,
    required this.docRef,
  });

  factory PairSessionModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PairSessionModel(
      docRef: doc.reference,
      name: data['name'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createdAt': createdAt,
    };
  }

  static CollectionReference<PairSessionModel> withCollectionConverter(
      CollectionReference collectionReference) {
    return collectionReference.withConverter<PairSessionModel>(
      fromFirestore: (snapshot, _) => PairSessionModel.fromFirestore(snapshot),
      toFirestore: (pairSession, _) => pairSession.toJson(),
    );
  }

  static DocumentReference<PairSessionModel> withDocumentConverter(
      DocumentReference documentReference) {
    return documentReference.withConverter<PairSessionModel>(
      fromFirestore: (snapshot, _) => PairSessionModel.fromFirestore(snapshot),
      toFirestore: (pairSession, _) => pairSession.toJson(),
    );
  }
}

final pairSessionCollection = mainDb.collection('pair_sessions');
final pairSessionWithConverterCollection =
    PairSessionModel.withCollectionConverter(pairSessionCollection);
