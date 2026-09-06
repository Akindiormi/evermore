import 'package:flutter_test/flutter_test.dart';
import 'package:evermore/data/course_catalog.dart';
import 'package:evermore/services/account_service.dart';

void main() {
  group('Evermore course catalogue', () {
    test('contains 50 or more meaningful courses', () {
      expect(courseCatalog.length, greaterThanOrEqualTo(50));
    });

    test('contains all required learning categories', () {
      const required = {
        'Digital Skills',
        'Financial Literacy',
        'Career Growth',
        'Communication',
        'Business & Entrepreneurship',
      };
      expect(courseCatalog.map((course) => course.category).toSet(),
          containsAll(required));
    });

    test('every course has lessons', () {
      expect(courseCatalog.every((course) => course.lessons.isNotEmpty), true);
    });
  });

  group('Account service', () {
    test('service can be instantiated', () {
      expect(AccountService(), isA<AccountService>());
    });
  });
}
