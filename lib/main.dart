import 'logics/providers/file_provider.dart';
import 'view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FileProvider>(
          create: (context) => FileProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter File App',
        home: HomeScreen(),
      ),
    );
  }
}
