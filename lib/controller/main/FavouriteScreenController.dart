import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../components/AppColors.dart';

class FavouriteScreenController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  RxString dailyHadees = ''.obs;
  RxString hadeesTranslation = ''.obs;
  RxString hadeesReference = ''.obs;

  RxString dailyAyat = ''.obs;
  RxString ayatTranslation = ''.obs;
  RxString ayatReference = ''.obs;

  RxSet<String> savedVerseIds = <String>{}.obs; // store IDs of saved items
  RxSet<String> savedHadithIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadAyat();
    loadHadees();
    loadSavedItems();
  }

  Future<void> loadAyat() async {
    try {
      final doc = await db.collection('verseOfTheDay').doc('current').get();
      if (doc.exists) {
        dailyAyat.value = doc['verse'] ?? '';
        ayatTranslation.value = doc['urduTranslation'] ?? '';
        ayatReference.value = doc['reference'] ?? '';
      }
    } catch (e) {
      print("Error loading ayat: $e");
    }
  }

  Future<void> loadHadees() async {
    try {
      final doc = await db.collection('hadithOfTheDay').doc('current').get();
      if (doc.exists) {
        dailyHadees.value = doc['hadith'] ?? '';
        hadeesTranslation.value = doc['urduTranslation'] ?? '';
        hadeesReference.value = doc['reference'] ?? '';
      }
    } catch (e) {
      print("Error loading hadith: $e");
    }
  }

  /// Load saved items for the current user
  Future<void> loadSavedItems() async {
    final user = auth.currentUser;
    if (user == null) return;

    try {
      final snapshot = await db
          .collection("favorites")
          .where("userId", isEqualTo: user.uid)
          .get();

      final verseIds = <String>{};
      final hadithIds = <String>{};

      for (var doc in snapshot.docs) {
        final type = doc['type'];
        final itemId = doc['item']['id'] ?? '';
        if (type == 'verse') {
          verseIds.add(itemId);
        } else if (type == 'hadith') {
          hadithIds.add(itemId);
        }
      }

      savedVerseIds.value = verseIds;
      savedHadithIds.value = hadithIds;
    } catch (e) {
      print("Error loading saved items: $e");
    }
  }

  /// Save or remove favorite
  Future<void> toggleFavorite({
    required String type, // 'verse' or 'hadith'
    required String content,
    required String translation,
    required String reference,
    required String id, // unique ID to identify the item
  }) async {
    final user = auth.currentUser;
    if (user == null) return;

    final collection = db.collection('favorites');

    try {
      if ((type == 'verse' && savedVerseIds.contains(id)) ||
          (type == 'hadith' && savedHadithIds.contains(id))) {
        // Remove from favorites
        final snapshot = await collection
            .where("userId", isEqualTo: user.uid)
            .where("type", isEqualTo: type)
            .where("item.id", isEqualTo: id)
            .get();

        for (var doc in snapshot.docs) {
          await collection.doc(doc.id).delete();
        }

        if (type == 'verse') {
          savedVerseIds.remove(id);
        } else {
          savedHadithIds.remove(id);
        }Fluttertoast.showToast(
          msg: "پسندیدہ سے ہٹا دیا گیا",
          toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
          gravity: ToastGravity.BOTTOM,    // top, center, bottom
          timeInSecForIosWeb: 1,           // iOS & web
          backgroundColor: AppColors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print("$type Removed from favorites");
      } else {
        // Add to favorites
        await collection.doc().set({
          "type": type,
          "userId": user.uid,
          "dateAdded": FieldValue.serverTimestamp(),
          "item": {
            "id": id,
            "verse": type == "verse" ? content : null,
            "hadith": type == "hadith" ? content : null,
            "urduTranslation": translation,
            "reference": reference,
            "dateAdded": FieldValue.serverTimestamp(),
          }
        });

        if (type == 'verse') {
          savedVerseIds.add(id);
        } else {
          savedHadithIds.add(id);
        }
        Fluttertoast.showToast(
          msg: "پسندیدہ میں شامل کر دیا گیا",
          toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
          gravity: ToastGravity.BOTTOM,    // top, center, bottom
          timeInSecForIosWeb: 1,           // iOS & web
          backgroundColor: AppColors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        print("$type added to favorites");
      }
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }
}