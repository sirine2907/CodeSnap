import 'dart:typed_data';

import 'package:codesnap/features/export/domain/repositories/export_repository.dart';
import 'package:codesnap/features/export/domain/usecases/save_image.dart';
import 'package:codesnap/features/export/domain/usecases/share_image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExportRepository extends Mock implements ExportRepository {}

void main() {
  late MockExportRepository repository;
  final bytes = Uint8List.fromList([1, 2, 3]);

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    repository = MockExportRepository();
  });

  group('makeFileName', () {
    test('turns the title into a safe file name', () {
      expect(makeFileName('My Cool Snippet!'), 'my-cool-snippet.png');
    });

    test('keeps dots out of the name', () {
      expect(makeFileName('main.go'), 'main-go.png');
    });

    test('falls back to codesnap when title is empty', () {
      expect(makeFileName('  '), 'codesnap.png');
    });
  });

  test('SaveImage saves the png with a nice file name', () async {
    when(() => repository.savePng(any(), any())).thenAnswer((_) async => true);

    final result = await SaveImage(repository)(bytes, 'fetch_users.py');

    expect(result, isTrue);
    verify(() => repository.savePng(bytes, 'fetch-users-py.png')).called(1);
  });

  test('ShareImage shares the png', () async {
    when(() => repository.sharePng(any(), any())).thenAnswer((_) async {});

    await ShareImage(repository)(bytes, 'main.go');

    verify(() => repository.sharePng(bytes, 'main-go.png')).called(1);
  });
}
