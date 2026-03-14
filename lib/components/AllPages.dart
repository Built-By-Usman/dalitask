import 'package:get/get.dart';
import '../pages/auth/LoginScreen.dart';
import '../pages/auth/SignUpScreen.dart';
import '../pages/auth/SplashScreen.dart';
import '../pages/main/FavouriteHadithVerse.dart';
import '../pages/main/MainScreen.dart';
import '../pages/main/NameScreen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const main = '/';
  static const names = '/names';
  static const favouriteHadithVerse = '/favouriteHadithVerse';
  static final pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: signup, page: () => SignUpScreen()),
    GetPage(name: main, page: () => MainScreen()),
    GetPage(name: names, page: () => NamesScreen()),
    GetPage(
      name: AppRoutes.favouriteHadithVerse,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final favouriteType = args?['favouriteType'] ?? 'hadith';
        return FavouriteHadithVerse(favouriteType: favouriteType);
      },
    ),
  ];


}
