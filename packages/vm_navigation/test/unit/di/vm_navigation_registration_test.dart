import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_navigation/vm_navigation.dart';

void main() {
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.asNewInstance();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('registerVmNavigationModule', () {
    test('registers a VmNavigatorService', () {
      registerVmNavigationModule(getIt);

      expect(getIt<VmNavigatorService>(), isA<VmNavigatorService>());
    });

    test('returns and registers the same GlobalKey<NavigatorState>', () {
      final returnedKey = registerVmNavigationModule(getIt);

      expect(getIt<GlobalKey<NavigatorState>>(), same(returnedKey));
    });
  });
}
