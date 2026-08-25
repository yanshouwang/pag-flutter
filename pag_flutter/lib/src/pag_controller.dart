import 'package:flutter/foundation.dart';
import 'package:pag_platform_interface/pag_platform_interface.dart';

import 'pag_value.dart';

abstract base class PAGController extends ValueNotifier<PAGValue> {
  PAGController.impl() : super(.uninitialized);

  factory PAGController.asset(
    String asset, {
    PAGScaleMode scaleMode = .letterBox,
    int repeatCount = 0,
    double progress = 0.0,
  }) => PAGControllerImpl(
    composition: PAGPlugin.instance.newPAGFileWithAsset(asset),
    scaleMode: scaleMode,
    repeatCount: repeatCount,
    progress: progress,
  );

  factory PAGController.file(
    String file, {
    PAGScaleMode scaleMode = .letterBox,
    int repeatCount = 0,
    double progress = 0.0,
  }) => PAGControllerImpl(
    composition: PAGPlugin.instance.newPAGFileWithFile(file),
    scaleMode: scaleMode,
    repeatCount: repeatCount,
    progress: progress,
  );

  factory PAGController.bytes(
    Uint8List bytes, {
    PAGScaleMode scaleMode = .letterBox,
    int repeatCount = 0,
    double progress = 0.0,
  }) => PAGControllerImpl(
    composition: PAGPlugin.instance.newPAGFileWithBytes(bytes),
    scaleMode: scaleMode,
    repeatCount: repeatCount,
    progress: progress,
  );

  Future<void> setScaleMode(PAGScaleMode value);
  Future<void> setRepeatCount(int value);
  Future<void> setProgress(double value);
  Future<void> play();
  Future<void> pause();
  Future<void> stop();
}

final class PAGControllerImpl extends PAGController {
  final PAGView view;

  PAGControllerImpl({
    required PAGComposition composition,
    PAGScaleMode? scaleMode,
    int? repeatCount,
    double? progress,
  }) : view = PAGPlugin.instance.newPAGView(
         composition: composition,
         scaleMode: scaleMode,
         repeatCount: repeatCount,
         progress: progress,
       ),
       super.impl();

  @override
  Future<void> setScaleMode(PAGScaleMode value) => view.setScaleMode(value);

  @override
  Future<void> setRepeatCount(int value) => view.setRepeatCount(value);

  @override
  Future<void> setProgress(double value) => view.setProgress(value);

  @override
  Future<void> play() => view.play();

  @override
  Future<void> pause() => view.pause();

  @override
  Future<void> stop() => view.stop();
}

extension PAGControllerX on PAGController {
  PAGView get view {
    final impl = this;
    if (impl is! PAGControllerImpl) {
      throw TypeError();
    }
    return impl.view;
  }
}
