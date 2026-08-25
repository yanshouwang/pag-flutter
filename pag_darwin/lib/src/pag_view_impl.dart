import 'package:pag_platform_interface/pag_platform_interface.dart';

import 'api.g.dart';
import 'api.x.dart';

final class PAGViewImpl extends PAGView {
  PAGViewApi api;

  PAGViewImpl() : api = PAGViewApi(), super.impl();

  @override
  Future<PAGComposition> getComposition() async {
    final value = await api.getComposition();
    return value.impl;
  }

  @override
  Future<void> setCompositon(PAGComposition value) async {
    await api.setCompositon(value.api);
  }

  @override
  Future<int> getRepeatCount() async {
    final value = api.getRepeatCount();
    return value;
  }

  @override
  Future<void> setRepeatCount(int value) async {
    await api.setRepeatCount(value);
  }

  @override
  Future<PAGScaleMode> getScaleMode() async {
    final value = await api.getScaleMode();
    return value.impl;
  }

  @override
  Future<void> setScaleMode(PAGScaleMode value) async {
    await api.setScaleMode(value.api);
  }

  @override
  Future<double> getProgress() async {
    final value = await api.getProgress();
    return value;
  }

  @override
  Future<void> setProgress(double value) async {
    await api.setProgress(value);
  }

  @override
  Future<bool> isPlaying() async {
    final value = await api.isPlaying();
    return value;
  }

  @override
  Future<void> play() async {
    await api.play();
  }

  @override
  Future<void> pause() async {
    await api.pause();
  }

  @override
  Future<void> stop() async {
    await api.stop();
  }
}

extension PAGViewX on PAGView {
  PAGViewApi get api {
    final impl = this;
    if (impl is! PAGViewImpl) throw TypeError();
    return impl.api;
  }
}
