import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_storage/vm_storage.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

final getIt = GetIt.instance;

/// Thin runnable shell: registers `vm_storyboard` (theme) and `vm_storage`
/// (with mock, easy-to-tweak config opting into all three stores) then runs
/// `StorageDemoScreen`, which lives in `package:vm_storage` itself so any app
/// can embed it the same way (see `docs/module-scaffold.md`).
void main() {
  registerVmStoryboardModule(
    getIt,
    config: VmThemeConfig(palette: VmColorPalette.mock(), logo: VmLogo.mock()),
  );

  registerVmStorageModule(
    getIt,
    config: const VmStorageConfig(
      namespace: 'vm_storage_example',
      enableSecureStore: true,
      documentCollections: [
        // Easy to tweak: shorten the TTL or flip soft-delete to see the
        // demo behave differently.
        VmDocumentCollectionConfig(
          name: StorageDemoScreen.collection,
          defaultTtl: Duration(minutes: 5),
          softDeleteEnabled: true,
        ),
      ],
    ),
  );

  runApp(const VmStorageExampleApp());
}

class VmStorageExampleApp extends StatelessWidget {
  const VmStorageExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = getIt<VmTheme>();
    return MaterialApp(
      title: 'vm_storage example',
      theme: theme.light,
      darkTheme: theme.dark,
      home: const StorageDemoScreen(),
    );
  }
}
