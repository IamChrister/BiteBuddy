import 'dart:convert';
import 'package:bite_buddy/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GPTService {
  final String _apiKey = dotenv.get('OPENAI_API_KEY');
  final String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<GPTRecommendations> generateText(ShoppingList shoppingList) async {
    final prompt = '''
Based on the following shopping list give alternatives that are healthier and have a lower carbon footprint if I live in estonia. Here is my shopping list:
* Kommid
* Krõpsud
* Piim
* Hakkliha
* Jahu
* Viinamarjad

Answer only with a JSON in the following format:
{
  "items": [
	{"original_item": "original item name", "substitution_item": "substitution item name", "reasoning": "Why is the substitution better?"
	]
}

Do not respond with anything else except the JSON
''';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'messages': [
          {"role": "user", "content": prompt}
        ],
        "model": "gpt-3.5-turbo",
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final content = data['choices'][0]['message']["content"]['items'];
      print("Content: $content");

      return GPTRecommendations.fromJson(json.decode(content));
    } else {
      print(response.body);
      throw Exception('Failed to generate text');
    }
  }
}

class GPTRecommendations {
  final List<SubstitutionRecomendation> recommendations;

  GPTRecommendations({required this.recommendations});

  factory GPTRecommendations.fromJson(List<dynamic> json) {
    List<SubstitutionRecomendation> recommendations =
        json.map((item) => SubstitutionRecomendation.fromJson(item)).toList();
    return GPTRecommendations(recommendations: recommendations);
  }
}

class SubstitutionRecomendation {
  final String originalItem;
  final String substitutionItem;
  final String reasoning;

  factory SubstitutionRecomendation.fromJson(Map<String, dynamic> json) {
    return SubstitutionRecomendation(
        originalItem: json['originalItem'],
        substitutionItem: json["substitutionItem"],
        reasoning: json["reasoning"]);
  }

  SubstitutionRecomendation(
      {required this.originalItem,
      required this.substitutionItem,
      required this.reasoning});
}
