import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/bloc/shopping_list_bloc.dart';
import 'presentation/pages/home_screen.dart';
import 'injection_container.dart' as dependency_injection;

void main() {
  dependency_injection.init();
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
