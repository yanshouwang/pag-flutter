import 'dart:async';
import 'dart:js_interop' as web;

import 'package:pag_platform_interface/pag_platform_interface.dart';
import 'package:web/web.dart' as web;

import 'js_interop.dart' as web;
import 'pag_composition_impl.dart';
import 'pag_scale_mode.dart';

final class PAGViewImpl extends PAGView {
  final web.HTMLCanvasElement canvas;

  late final FutureOr<web.PAGView> api;
  late final Future<web.ResizeObserver> observer;

  PAGViewImpl({
    required PAGComposition composition,
    PAGScaleMode? scaleMode,
    int? repeatCount,
    double? progress,
  }) : canvas = web.HTMLCanvasElement(),
       super.impl() {
    api = web.libPAG.then((libPAG) async {
      final compositionApi = await composition.api;
      final initOptions = web.PAGViewOptions()..useScale = false;
      return libPAG.PAGView.init(compositionApi, canvas, initOptions).toDart;
    });
    // observer = Future.value(api).then(
    //   (api) => web.ResizeObserver(
    //     ((
    //           web.JSArray<web.ResizeObserverEntry> entries,
    //           web.ResizeObserver observer,
    //         ) {
    //           final rect = canvas.getBoundingClientRect();
    //           final devicePixelRatio = web.window.devicePixelRatio;
    //           canvas.width = (rect.width * devicePixelRatio).round();
    //           canvas.height = (rect.height * devicePixelRatio).round();
    //           api.updateSize();
    //           api.flush();
    //         })
    //         .toJS,
    //   )..observe(canvas),
    // );
  }

  @override
  Future<PAGComposition> getComposition() async {
    final api = await this.api;
    final value = api.getComposition().impl;
    return value;
  }

  @override
  Future<void> setCompositon(PAGComposition value) async {
    final api = await this.api;
    final compositionApi = await value.api;
    api.setComposition(compositionApi);
    await api.flush().toDart;
  }

  @override
  Future<PAGScaleMode> getScaleMode() async {
    final api = await this.api;
    final value = api.scaleMode().impl;
    return value;
  }

  @override
  Future<void> setScaleMode(PAGScaleMode value) async {
    final api = await this.api;
    api.setScaleMode(value.api);
    await api.flush().toDart;
  }

  @override
  Future<int> getRepeatCount() async {
    final api = await this.api;
    final value = api.repeatCount;
    return value;
  }

  @override
  Future<void> setRepeatCount(int value) async {
    final api = await this.api;
    api.setRepeatCount(value);
  }

  @override
  Future<double> getProgress() async {
    final api = await this.api;
    final value = api.getProgress().toDouble();
    return value;
  }

  @override
  Future<void> setProgress(double value) async {
    final api = await this.api;
    api.setProgress(value);
    await api.flush().toDart;
  }

  @override
  Future<bool> isPlaying() async {
    final api = await this.api;
    final value = api.isPlaying;
    return value;
  }

  @override
  Future<void> play() async {
    final api = await this.api;
    await api.play().toDart;
  }

  @override
  Future<void> pause() async {
    final api = await this.api;
    api.pause();
  }

  @override
  Future<void> stop() async {
    final api = await this.api;
    await api.stop().toDart;
  }
}

extension PAGViewX on PAGView {
  web.HTMLCanvasElement get canvas {
    final impl = this;
    if (impl is! PAGViewImpl) throw TypeError();
    return impl.canvas;
  }
}
