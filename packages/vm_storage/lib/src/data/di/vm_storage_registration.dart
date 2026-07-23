import 'package:get_it/get_it.dart';

import '../../domain/document_store.dart';
import '../../domain/key_value_store.dart';
import '../../domain/secure_store.dart';
import '../../domain/vm_storage_config.dart';
import '../document/hive_document_store_factory.dart';
import '../key_value/shared_preferences_key_value_store.dart';
import '../secure/flutter_secure_storage_secure_store.dart';

/// Single registration entry point for `vm_storage`. Receives its [config]
/// from the consuming app — nothing here is hard-coded. Registration is
/// selective: `SecureStore` and `DocumentStoreFactory` are registered only
/// when the app opts into them via [config].
void registerVmStorageModule(GetIt getIt, {required VmStorageConfig config}) {
  getIt.registerSingleton<VmStorageConfig>(config);

  if (config.enableKeyValueStore) {
    getIt.registerSingleton<KeyValueStore>(
      SharedPreferencesKeyValueStore(namespace: config.namespace),
    );
  }

  if (config.enableSecureStore) {
    getIt.registerSingleton<SecureStore>(
      FlutterSecureStorageSecureStore(namespace: config.namespace),
    );
  }

  if (config.enableDocumentStore) {
    getIt.registerSingleton<DocumentStoreFactory>(
      HiveDocumentStoreFactory(config: config),
    );
  }
}
