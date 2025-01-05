import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore mainDb = FirebaseFirestore.instance;

final CollectionReference playerCollection = mainDb
    .collection("badminton_players");