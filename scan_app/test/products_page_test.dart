import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:scan_app/pages/products.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late MockUser mockUser;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    mockUser = MockUser(uid: 'test_user');
    mockAuth = MockFirebaseAuth(mockUser: mockUser);
  });

  testWidgets('adds product to Firestore', (tester) async {
    final widget = MaterialApp(
      home: ProductsPage(
        firestore: firestore,
        auth: mockAuth,
      ),
    );

    await tester.pumpWidget(widget);

    await tester.enterText(find.byType(TextField), 'Ябълка');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    final snapshot = await firestore
        .collection('users')
        .doc('test_user')
        .collection('extractedData')
        .doc('products')
        .get();

    final products = snapshot.data()?['products'] as List?;
    expect(products, contains('Ябълка'));
  });
}
