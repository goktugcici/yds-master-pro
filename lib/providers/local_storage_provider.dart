import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local_storage.dart';

final localStorageProvider = Provider<LocalStorage>((ref) {
  throw UnimplementedError('LocalStorage must be initialized in main()');
});
