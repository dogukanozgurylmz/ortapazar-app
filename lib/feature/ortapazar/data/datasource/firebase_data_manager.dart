import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataManager {
  late FirebaseFirestore firestore;

  FirebaseDataManager() {
    firestore = FirebaseFirestore.instance;
  }
}
