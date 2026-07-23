import 'package:flutter_test/flutter_test.dart';
import 'package:vm_analytics/vm_analytics.dart';

void main() {
  group('AnalyticsEvent', () {
    test('two instances with equal name and parameters compare as equal', () {
      final a = AnalyticsEvent(
        name: 'checkout_started',
        parameters: const {'item_count': 3},
      );
      final b = AnalyticsEvent(
        name: 'checkout_started',
        parameters: const {'item_count': 3},
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('instances with different parameters are not equal', () {
      final a = AnalyticsEvent(
        name: 'checkout_started',
        parameters: const {'item_count': 3},
      );
      final b = AnalyticsEvent(
        name: 'checkout_started',
        parameters: const {'item_count': 4},
      );

      expect(a, isNot(equals(b)));
    });

    test('valid snake_case name is accepted', () {
      expect(() => AnalyticsEvent(name: 'checkout_started'), returnsNormally);
    });

    test('rejects a name with spaces', () {
      expect(
        () => AnalyticsEvent(name: 'checkout started'),
        throwsArgumentError,
      );
    });

    test('rejects a camelCase name', () {
      expect(
        () => AnalyticsEvent(name: 'checkoutStarted'),
        throwsArgumentError,
      );
    });

    test('rejects a name over the max length', () {
      final tooLong = 'a' * (kAnalyticsNameMaxLength + 1);
      expect(() => AnalyticsEvent(name: tooLong), throwsArgumentError);
    });

    test('rejects an empty name', () {
      expect(() => AnalyticsEvent(name: ''), throwsArgumentError);
    });

    test('defaults parameters to an empty map', () {
      final event = AnalyticsEvent(name: 'app_opened');
      expect(event.parameters, isEmpty);
    });
  });

  group('validateAnalyticsName', () {
    test('accepts a valid snake_case name', () {
      expect(
        validateAnalyticsName('product_viewed', label: 'name'),
        'product_viewed',
      );
    });

    test('rejects a name starting with a digit', () {
      expect(
        () => validateAnalyticsName('1event', label: 'name'),
        throwsArgumentError,
      );
    });
  });

  group('sanitizeAnalyticsName', () {
    test('lowercases and collapses non-alphanumeric runs to underscores', () {
      expect(sanitizeAnalyticsName('Product Details'), 'product_details');
    });

    test('strips leading digits/underscores', () {
      expect(sanitizeAnalyticsName('/product/42'), 'product_42');
    });

    test('returns null when nothing usable remains', () {
      expect(sanitizeAnalyticsName('///'), isNull);
    });

    test('bounds the result to the max length', () {
      final raw = 'a' * (kAnalyticsNameMaxLength + 10);
      final sanitized = sanitizeAnalyticsName(raw);
      expect(sanitized, isNotNull);
      expect(sanitized!.length, lessThanOrEqualTo(kAnalyticsNameMaxLength));
    });
  });
}
