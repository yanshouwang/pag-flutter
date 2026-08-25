import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@immutable
final class PAGValue {
  static PAGValue get uninitialized => PAGValue(progress: 0.0);

  final double progress;

  const PAGValue({required this.progress});

  PAGValue copyWith({double? progress}) =>
      PAGValue(progress: progress ?? this.progress);

  @override
  int get hashCode => progress.hashCode;

  @override
  bool operator ==(Object other) =>
      other is PAGValue && other.progress == progress;
}
