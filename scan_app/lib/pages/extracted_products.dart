import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const _apiKey = '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'; // Insert your OpenAI API key here
  static const _endpoint = 'https://api.openai.com/v1/chat/completions';

  static Future<String> generateMealIdeas(String inputText) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-4o', 
        'temperature': 0.2,
        'messages': [
          {
            'role': 'system',
            'content': '''
Ти си професионален нутриционист и експерт по текстова обработка.

Получаваш неструктуриран текст, извлечен чрез OCR от етикет на храна или касова бележка.

Твоята задача е да върнеш САМО списък c хранителни продукти преведени НА БЪЛГАРСКИ или съставки**, които откриваш в текста. Всеки продукт трябва да е на нов ред, без номерация, без описание, без повтаряне.  
...
'''
          },
          {
            'role': 'user',
            'content': 'OCR текст:\n$inputText',
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to extract products: ${response.statusCode} ${response.body}');
    }
  }
}
