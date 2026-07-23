import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../domain/formatting.dart';
import '../../locale/vm_locale_cubit.dart';
import '../../locale/vm_locale_state.dart';

/// Language selector (driven by `VmLocaleCubit`) plus sample date/number/
/// currency displays that re-render whenever the active locale changes.
class LocaleSection extends StatelessWidget {
  const LocaleSection({
    required this.dateFormatter,
    required this.numberFormatter,
    required this.currencyFormatter,
    super.key,
  });

  final VmDateFormatter dateFormatter;
  final VmNumberFormatter numberFormatter;
  final VmCurrencyFormatter currencyFormatter;

  static final _sampleDate = DateTime(2026, 3, 5);
  static const _sampleNumber = 1234.5;
  static const _sampleAmount = 19.9;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    return BlocBuilder<VmLocaleCubit, VmLocaleState>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.all(tokens.spacing.md),
          children: [
            VmCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Language',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: tokens.spacing.sm),
                  VmSegmentedControl<Locale>(
                    segments: [
                      for (final locale in state.supportedLocales)
                        VmSegment(value: locale, label: locale.toLanguageTag()),
                    ],
                    selected: state.locale,
                    onChanged: (locale) =>
                        context.read<VmLocaleCubit>().changeLocale(locale),
                  ),
                ],
              ),
            ),
            SizedBox(height: tokens.spacing.md),
            VmCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Locale-aware formatting',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: tokens.spacing.sm),
                  VmListItem(
                    title: const Text('Date'),
                    subtitle: Text(
                      dateFormatter.format(_sampleDate, state.locale),
                    ),
                  ),
                  VmListItem(
                    title: const Text('Number'),
                    subtitle: Text(
                      numberFormatter.format(_sampleNumber, state.locale),
                    ),
                  ),
                  VmListItem(
                    title: const Text('Currency'),
                    subtitle: Text(
                      currencyFormatter.format(_sampleAmount, state.locale),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
