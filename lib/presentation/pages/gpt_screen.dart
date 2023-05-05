import 'package:bite_buddy/presentation/bloc/shopping_list_bloc.dart';
import 'package:bite_buddy/services/gpt_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GPTScreen extends StatefulWidget {
  const GPTScreen({super.key, required this.results});
  final GPTRecommendations results;

  @override
  State<GPTScreen> createState() => _GPTScreenState();
}

class _GPTScreenState extends State<GPTScreen> {
  final GPTService _gptService = GPTService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bite Buddy')),
      body: Center(child: Text("Result will be here")),
    );
  }
}
