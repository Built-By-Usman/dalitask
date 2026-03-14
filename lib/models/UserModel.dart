class UserModel {
  String name;
  String email;
  int dailyGoal;
  int monthlyGoal;
  int monthCount;
  int streak;
  int todayCount;
  int totalCount;
  int referralCount;
  String lastLoginDate;
  String lastMonthResetDate;
  bool isBlocked;
  String referredBy;
  String referredAt;
  String referralCode;
  Map<String, dynamic> payout;

  UserModel({
    required this.name,
    required this.email,
    required this.dailyGoal,
    required this.monthlyGoal,
    required this.monthCount,
    required this.streak,
    required this.isBlocked,
    required this.todayCount,
    required this.totalCount,
    required this.referralCount,
    required this.lastLoginDate,
    required this.lastMonthResetDate,
    required this.referredAt,
    required this.referredBy,
    required this.referralCode,
    required this.payout,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      dailyGoal: map['dailyGoal'] ?? 0,
      monthlyGoal: map['monthlyGoal'] ?? 0,
      monthCount: map['monthCount'] ?? 0,
      streak: map['streak'] ?? 0,
      isBlocked:map['isBlocked']??false,
      referralCount: map['referralCount']??0,
      todayCount: map['todayCount'] ?? 0,
      totalCount: map['totalCount'] ?? 0,
      lastLoginDate: map['lastLoginDate'] ?? '',
      lastMonthResetDate: map['lastMonthResetDate'] ?? '',
      referredAt: map['referredAt']??'',
      referredBy: map['referredBy']??'',
      referralCode: map['referralCode']??'',
      payout: Map<String, dynamic>.from(map['payout'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'dailyGoal': dailyGoal,
      'monthlyGoal': monthlyGoal,
      'monthCount': monthCount,
      'streak': streak,
      'isBlocked':isBlocked,
      'todayCount': todayCount,
      'totalCount': totalCount,
      'lastLoginDate': lastLoginDate,
      'lastMonthResetDate': lastMonthResetDate,
      'referredBy':referredBy,
      'referredAt':referredAt,
      'referralCode':referralCode,
      'referralCount':referralCount,
      'payout': payout,
    };
  }
}
