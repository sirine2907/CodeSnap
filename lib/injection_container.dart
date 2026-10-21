import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/editor/presentation/bloc/editor_bloc.dart';
import 'features/export/data/repositories/export_repository_impl.dart';
import 'features/export/domain/repositories/export_repository.dart';
import 'features/export/domain/usecases/save_image.dart';
import 'features/export/domain/usecases/share_image.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/get_dark_mode.dart';
import 'features/settings/domain/usecases/save_dark_mode.dart';
import 'features/snippets/data/datasources/snippet_local_data_source.dart';
import 'features/snippets/data/repositories/snippet_repository_impl.dart';
import 'features/snippets/domain/repositories/snippet_repository.dart';
import 'features/snippets/domain/usecases/delete_snippet.dart';
import 'features/snippets/domain/usecases/get_snippets.dart';
import 'features/snippets/domain/usecases/save_snippet.dart';
import 'features/snippets/presentation/bloc/library_bloc.dart';

final sl = GetIt.instance;

// [prefs] can be passed in tests, otherwise we use the real ones.
Future<void> init({SharedPreferences? prefs}) async {
  await sl.reset();

  final sharedPreferences = prefs ?? await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Snippets
  sl.registerLazySingleton<SnippetLocalDataSource>(
    () => SnippetLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SnippetRepository>(
    () => SnippetRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetSnippets(sl()));
  sl.registerLazySingleton(() => SaveSnippet(sl()));
  sl.registerLazySingleton(() => DeleteSnippet(sl()));
  sl.registerFactory(
    () => LibraryBloc(getSnippets: sl(), deleteSnippet: sl()),
  );

  // Export
  sl.registerLazySingleton<ExportRepository>(() => ExportRepositoryImpl());
  sl.registerLazySingleton(() => SaveImage(sl()));
  sl.registerLazySingleton(() => ShareImage(sl()));

  // Settings
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetDarkMode(sl()));
  sl.registerLazySingleton(() => SaveDarkMode(sl()));

  // Editor
  sl.registerFactory(
    () => EditorBloc(saveSnippet: sl(), saveImage: sl(), shareImage: sl()),
  );
}
