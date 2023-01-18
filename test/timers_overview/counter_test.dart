import 'package:flutter_test/flutter_test.dart';
import 'package:quick_timer/timers_overview/counter.dart';

void main() {
  group('Counter', () {
    const counter = Counter();

    test('counter emits 3 values from 2-0 every second', () {
      expectLater(
        counter.countdown(seconds: 3),
        emitsInOrder(<int>[2, 1, 0]),
      );
    });
  });
}
