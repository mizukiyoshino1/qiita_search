import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qiita_search/screens/home_screen.dart';
import 'package:qiita_search/screens/search_screen.dart';
import 'package:qiita_search/screens/profile_screen.dart';
import 'package:qiita_search/screens/signup_screen.dart';
import 'package:qiita_search/screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // Firebase 初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await dotenv.load(fileName: '.env');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qiita Search',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Hiragino Sans',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF55C500),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: const Color.fromARGB(255, 216, 216, 216),
            ),
      ),
      routes: {
        '/home': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),
        '/profile': (context) => ProfileScreen(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
      },
      // 最初に表示されるWidgetをAuthCheckに設定
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // ユーザーがログインしている場合、ホーム画面に遷移
          return HomeScreen();
        } else {
          // ログインしていない場合、ログイン画面に遷移
          return const LoginScreen();
        }
      },
    );
  }
}
