import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'presentation/bloc/shopping_list_bloc.dart';
import 'presentation/pages/home_screen.dart';
import 'injection_container.dart' as dependency_injection;

Future<void> main() async {
  dependency_injection.init();
  await dotenv.load(fileName: ".env");
  runApp(BlocProvider(
      create: (context) => dependency_injection.sl<ShoppingListBloc>(),
      child: const ShoppingListApp()));
}

class ShoppingListApp extends StatelessWidget {
  const ShoppingListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiteBuddy',
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
