import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:scan_app/pages/openai_service.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';

class MockClient extends Mock implements http.Client {}

void main() {
  group('OpenAIService.generateMealIdeas', () {
    test('returns parsed product list on 200 response', () async {
      final client = MockClient();
      const input = "Мляко, Яйца, Хляб";
      const mockResponse = {
        "choices": [
          {
            "message": {
              "content": "Мляко\nЯйца\nХляб"
            }
          }
        ]
      };

      when(client.post(
        // ignore: cast_from_null_always_fails
        any as Uri,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await OpenAIService.generateRecipes(input);
      expect(result, contains("Мляко"));
      expect(result, contains("Яйца"));
    });

    test('throws exception on error response', () async {
      final client = MockClient();

      when(client.post(
        // ignore: cast_from_null_always_fails
        any as Uri,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response("Error", 500));

      expect(
        () async => await OpenAIService.generateRecipes("something"),
        throwsA(isA<Exception>()),
      );
    });
  });
}
