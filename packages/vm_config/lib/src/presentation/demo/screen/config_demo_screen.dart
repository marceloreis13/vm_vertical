import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../data/providers/static_map_config_provider.dart';
import '../../../domain/config_cache.dart';
import '../../../domain/config_map.dart';
import '../../../domain/config_reader.dart';
import '../config_demo_cubit.dart';
import '../sections/config_fields_section.dart';

/// Entry point of the `vm_config` visual example. Resolves the
/// app-registered [ConfigReader] (via `registerVmConfigModule`) and takes
/// the same [provider]/[cache] instances the app registered so the demo can
/// mutate them directly and show the observable change stream and the
/// remote > cache > default precedence live. Lives in `lib/`, not
/// `example/`, so any app can embed it directly (see
/// `docs/module-scaffold.md`).
class ConfigDemoScreen extends StatelessWidget {
  const ConfigDemoScreen({
    required this.provider,
    required this.defaultValues,
    this.cache,
    this.getIt,
    super.key,
  });

  final StaticMapConfigProvider provider;
  final ConfigMap defaultValues;
  final ConfigCache? cache;

  /// Defaults to [GetIt.instance]; overridable for tests/embedding apps
  /// with a scoped container.
  final GetIt? getIt;

  @override
  Widget build(BuildContext context) {
    final container = getIt ?? GetIt.instance;
    final reader = container<ConfigReader>();

    return BlocProvider(
      create: (_) => ConfigDemoCubit(
        reader: reader,
        provider: provider,
        defaultValues: defaultValues,
        cache: cache,
      ),
      child: Scaffold(
        appBar: const VmAppBar(title: 'vm_config example'),
        body: const ConfigFieldsSection(),
      ),
    );
  }
}
