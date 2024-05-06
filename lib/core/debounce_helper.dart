import 'dart:async';
import 'dart:ui';

class DeBouncerHelper {
  DeBouncerHelper({required this.milliseconds});
  final int milliseconds;
  Timer? _timer;
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer=null;
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}