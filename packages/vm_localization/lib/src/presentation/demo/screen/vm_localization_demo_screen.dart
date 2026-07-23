import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../domain/formatting.dart';
import '../../locale/vm_locale_cubit.dart';
import '../sections/locale_section.dart';

/// Entry point of the `vm_localization` visual example. Resolves the
/// app-registered formatters (via `registerVmLocalizationModule`) and shows
/// the language selector plus sample date/number/currency displays. Lives
/// in `lib/`, not `example/`, so any app can embed it directly (see
/// `docs/module-scaffold.md`).
class VmLocalizationDemoScreen extends StatelessWidget {
  const VmLocalizationDemoScreen({this.getIt, super.key});

  /// Defaults to [GetIt.instance]; overridable for tests/embedding apps
  /// with a scoped container.
  final GetIt? getIt;

  @override
  Widget build(BuildContext context) {
    final container = getIt ?? GetIt.instance;
    return BlocProvider.value(
      value: container<VmLocaleCubit>(),
      child: Scaffold(
        appBar: const VmAppBar(title: 'vm_localization example'),
        body: LocaleSection(
          dateFormatter: container<VmDateFormatter>(),
          numberFormatter: container<VmNumberFormatter>(),
          currencyFormatter: container<VmCurrencyFormatter>(),
        ),
      ),
    );
  }
}
