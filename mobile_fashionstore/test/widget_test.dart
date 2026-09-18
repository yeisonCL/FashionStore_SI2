import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_fashionstore/main.dart';

void main() {
  testWidgets('FashionStore Mobile smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FashionStoreMobileApp());
    expect(find.byType(FashionStoreMobileApp), findsOneWidget);
  });
}
