import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:gatoweb_client/pages/auth_page.dart';
import 'package:gatoweb_client/providers/language_provider.dart';
import 'package:gatoweb_client/providers/auth_provider.dart';

// Mocktail mocks
class MockLanguageProvider extends Mock implements LanguageProvider {}

class MockAuthProvider extends Mock implements AuthProvider {}

Widget buildTestableWidget(
  Widget child, {
  LanguageProvider? languageProvider,
  AuthProvider? authProvider,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LanguageProvider>.value(
        value: languageProvider ?? MockLanguageProvider(),
      ),
      ChangeNotifierProvider<AuthProvider>.value(
        value: authProvider ?? MockAuthProvider(),
      ),
    ],
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  late MockLanguageProvider mockLanguageProvider;
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockLanguageProvider = MockLanguageProvider();
    mockAuthProvider = MockAuthProvider();
  });

  testWidgets('User can see sign in form', (WidgetTester tester) async {
    when(() => mockLanguageProvider.language).thenReturn(AppLanguage.en);
    when(() => mockAuthProvider.user).thenReturn(null);

    await tester.pumpWidget(
      buildTestableWidget(
        const AuthPage(),
        languageProvider: mockLanguageProvider,
        authProvider: mockAuthProvider,
      ),
    );

    expect(find.text('Login'), findsWidgets);
    expect(find.byType(TextField), findsWidgets);
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}