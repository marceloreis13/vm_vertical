/// vm_storage: local persistence module for the vm_core platform. Three
/// typed, injectable stores — key-value, secure, and document — behind
/// stable interfaces. Hides the underlying backends (shared_preferences,
/// flutter_secure_storage, Hive CE) entirely.
library;

export 'src/core/failure.dart';
export 'src/core/result.dart';
export 'src/data/di/vm_storage_registration.dart';
export 'src/domain/document_store.dart';
export 'src/domain/key_value_store.dart';
export 'src/domain/secure_store.dart';
export 'src/domain/vm_storage_config.dart';
export 'src/presentation/demo/screen/storage_demo_screen.dart';
