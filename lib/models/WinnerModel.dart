import 'package:cloud_firestore/cloud_firestore.dart';

class WinnerModel {
  final String id;
  final String userName;
  final String rewardType;
  final DateTime dateAwarded;

  WinnerModel({
    required this.id,
    required this.userName,
    required this.rewardType,
    required this.dateAwarded,
  });

  factory WinnerModel.fromFirestore(String id, Map<String, dynamic> data) {
    return WinnerModel(
      id: id,
      userName: data['userName'] ?? '',
      rewardType: data['rewardType'] ?? '',
      dateAwarded: (data['dateAwarded'] as Timestamp).toDate(),
    );
  }
}