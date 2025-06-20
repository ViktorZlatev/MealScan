import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scan_app/pages/auth.dart';
// Mocks
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
// ignore: must_be_immutable, subtype_of_sealed_class
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
// ignore: subtype_of_sealed_class
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {

  setUp(() {
  });

  Widget createWidgetUnderTest() => MaterialApp(home: AuthScreen());

  group('AuthScreen tests', () {
    testWidgets('Initial UI shows login form', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2)); // username + password in login mode
      expect(find.text('Create an Account'), findsOneWidget);
    });

    testWidgets('Switch to Sign Up mode', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Create an Account'));
      await tester.pumpAndSettle();

      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3)); // username + email + password in signup mode
      expect(find.text('Already have an account? Login'), findsOneWidget);
    });

    testWidgets('Show error if username empty on login', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField).first, ''); // username
      await tester.enterText(find.byType(TextField).last, 'somepassword');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter your username.'), findsOneWidget);
    });

  });
  
}
