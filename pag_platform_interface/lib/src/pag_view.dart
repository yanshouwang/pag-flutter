import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pag_composition.dart';
import 'pag_scale_mode.dart';

abstract base class PAGView extends PlatformInterface {
  static final _token = Object();

  PAGView.impl() : super(token: _token);

  Future<PAGComposition> getComposition();
  Future<void> setCompositon(PAGComposition value);

  Future<int> getRepeatCount();
  Future<void> setRepeatCount(int value);

  Future<PAGScaleMode> getScaleMode();
  Future<void> setScaleMode(PAGScaleMode value);

  Future<double> getProgress();
  Future<void> setProgress(double value);

  Future<bool> isPlaying();
  Future<void> play();
  Future<void> pause();
  Future<void> stop();
}
