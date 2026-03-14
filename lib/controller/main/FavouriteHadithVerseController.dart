import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FavouriteHadithVerseController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  // Store all favourite items
  RxList<Map<String, dynamic>> favouriteItems = <Map<String, dynamic>>[].obs;

  /// Load favourites by type
  Future<void> loadFavourites(String type) async {
    try {
      final user = auth.currentUser;
      if (user == null) return;

      QuerySnapshot querySnapshot = await db
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .where('type', isEqualTo: type)
          .orderBy('dateAdded', descending: true) // latest first
          .get();

      favouriteItems.value = querySnapshot.docs.map((doc) {
        final data = doc['item'] as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error loading favourites: $e');
    }
  }

  /// Remove from favourites
  Future<void> unsaveItem(String docId) async {
    try {
      await db.collection('favorites').doc(docId).delete();
      favouriteItems.removeWhere((item) => item['id'] == docId);
    } catch (e) {
      print('Error removing favourite: $e');
    }
  }

  void shareItem(String content) {
    print("Sharing: $content");
    // integrate share plugin if needed
  }
}