import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  //static const _apiKey = ''; 
  static const _endpoint = 'https://api.openai.com/v1/chat/completions';

  static Future<String> generateRecipes(String inputText) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-4o', 
        'temperature': 0.7,
        'messages': [
          {
            'role': 'system',
            'content': '''
Ти си професионален готвач и експерт по текстова обработка.  
Първо, изчисти и коригирай текста на чист български език,  
след което върни САМО една част:  

1. **Списък с 10-15 рецепти**, като за всяка рецепта дадеш заглавие и дълго описание (как да се приготви), форматирани по следния начин:  

Рецепта 1: Заглавие  
Описание: Дълго описание как се приготвя.  

НЕ добавяй никакви други коментари или обяснения.
'''
          },
          {
            'role': 'user',
            'content': 'Текст от изображението (възможно неточен):\n$inputText',
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to generate recipes: ${response.statusCode} ${response.body}');
    }
  }
}
