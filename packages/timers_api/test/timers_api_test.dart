import 'package:test/test.dart';
import 'package:timers_api/src/timers_api.dart';

class TestTimersApi implements TimersApi {
  TestTimersApi() : super();

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('TimersApi', () {
    test('can be constructed', () {
      expect(TestTimersApi.new, returnsNormally);
    });
  });
}
