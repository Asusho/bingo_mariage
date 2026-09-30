import 'package:flutter_test/flutter_test.dart';

import 'package:bingo_mariage/main.dart';

void main() {
  testWidgets('draws a number and can start a new game', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BingoApp());

    expect(find.text('75 numéros restants sur 75'), findsOneWidget);
    expect(find.text('--'), findsOneWidget);
    expect(find.text('Les numéros tirés apparaîtront ici'), findsOneWidget);

    await tester.tap(find.text('Tirer un numéro'));
    await tester.pumpAndSettle();

    expect(find.text('74 numéros restants sur 75'), findsOneWidget);
    expect(find.text('--'), findsNothing);
    expect(find.text('1 tiré'), findsOneWidget);

    for (var draw = 0; draw < 5; draw++) {
      await tester.tap(find.text('Tirer un numéro'));
      await tester.pumpAndSettle();
    }

    expect(find.text('69 numéros restants sur 75'), findsOneWidget);
    expect(find.text('6 tirés'), findsOneWidget);

    await tester.tap(find.text('Nouvelle partie'));
    await tester.pumpAndSettle();

    expect(find.text('Nouvelle partie ?'), findsOneWidget);
    expect(
      find.text(
        'Le tirage actuel sera effacé. Voulez-vous vraiment recommencer ?',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();

    expect(find.text('69 numéros restants sur 75'), findsOneWidget);
    expect(find.text('Nouvelle partie ?'), findsNothing);

    await tester.tap(find.text('Nouvelle partie'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Recommencer'));
    await tester.pumpAndSettle();

    expect(find.text('75 numéros restants sur 75'), findsOneWidget);
    expect(find.text('--'), findsOneWidget);
    expect(find.text('Les numéros tirés apparaîtront ici'), findsOneWidget);
  });
}
