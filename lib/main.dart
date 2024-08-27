import 'package:flutter/material.dart';
import 'package:qiita_search/screens/home_screen.dart';
import 'package:qiita_search/screens/search_screen.dart';
import 'package:qiita_search/screens/profile_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qiita Search',
      initialRoute: '/search', // 初期画面

      // アプリ全体のテーマを定義
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Hiragino Sans',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF55C500),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
            ),
      ),

      // ルーティング
      routes: {
        '/home': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),
        '/profile': (context) => ProfileScreen(),
      },

      // 最初に表示されるWidget
      home: const SearchScreen(),
    );
  }
}
