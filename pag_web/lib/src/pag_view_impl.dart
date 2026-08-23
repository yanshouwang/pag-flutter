import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web' as web;

import 'package:flutter/widgets.dart';
import 'package:pag_platform_interface/pag_platform_interface.dart';
import 'package:web/web.dart' as web;

import 'js_interop.dart' as js;
import 'pag_composition_impl.dart';
import 'pag_scale_mode.dart';

const kPAGViewType = 'zeekr.dev/PAGView';

final class PAGViewImpl extends PAGView {
  final Completer<web.HTMLCanvasElement> canvas;
  final Completer<js.PAGView> api;

  PAGViewImpl() : canvas = Completer(), api = Completer(), super.impl();

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: kPAGViewType,
      onPlatformViewCreated: (viewId) {
        debugPrint('onPlatformViewCreated: $viewId');
        try {
          final value =
              web.platformViewRegistry.getViewById(viewId)
                  as web.HTMLCanvasElement;
          canvas.complete(value);
        } catch (e) {
          canvas.completeError(e);
        }
      },
    );
  }

  @override
  Future<PAGComposition> getComposition() async {
    final api = await this.api.future;
    final value = api.getComposition().impl;
    return value;
  }

  @override
  Future<double> getProgress() async {
    final api = await this.api.future;
    final value = api.getProgress().toDouble();
    return value;
  }

  @override
  Future<int> getRepeatCount() async {
    final api = await this.api.future;
    final value = api.repeatCount;
    return value;
  }

  @override
  Future<PAGScaleMode> getScaleMode() async {
    final api = await this.api.future;
    final value = api.scaleMode().impl;
    return value;
  }

  @override
  Future<bool> isPlaying() async {
    final api = await this.api.future;
    final value = api.isPlaying;
    return value;
  }

  @override
  Future<void> pause() async {
    final api = await this.api.future;
    api.pause();
  }

  @override
  Future<void> play() async {
    final api = await this.api.future;
    api.updateSize();
    await api.play().toDart;
  }

  @override
  Future<void> setCompositon(PAGComposition value) async {
    final compositionApi = await value.api;
    if (api.isCompleted) {
      final api = await this.api.future;
      api.setComposition(compositionApi);
    } else {
      final libPAG = await js.libPAG;
      final canvas = await this.canvas.future;
      // 按当前显示尺寸设置 canvas 缓冲，避免 init 默认 useScale=true
      // 将 canvas.style 覆盖为固定 px，导致 canvas 脱离 Flutter 布局。
      final rect = canvas.getBoundingClientRect();
      final devicePixelRatio = web.window.devicePixelRatio;
      canvas.width = (rect.width * devicePixelRatio).round();
      canvas.height = (rect.height * devicePixelRatio).round();
      final options = js.PAGViewOptions()..useScale = false;
      final api = await libPAG.PAGView.init(
        compositionApi,
        canvas,
        options,
      ).toDart;
      // 监听窗口 resize，同步 canvas 缓冲尺寸并重建 surface。
      // canvas style 保持 100%（useScale=false 不覆盖），
      // 窗口变化时 getBoundingClientRect 返回最新显示尺寸。
      web.window.onresize = ((web.Event _) {
        final rect = canvas.getBoundingClientRect();
        final devicePixelRatio = web.window.devicePixelRatio;
        canvas.width = (rect.width * devicePixelRatio).round();
        canvas.height = (rect.height * devicePixelRatio).round();
        api.updateSize();
        api.flush().toDart;
      }).toJS;
      this.api.complete(api);
    }
  }

  @override
  Future<void> setProgress(double value) async {
    final api = await this.api.future;
    api.setProgress(value);
  }

  @override
  Future<void> setRepeatCount(int value) async {
    final api = await this.api.future;
    api.setRepeatCount(value);
  }

  @override
  Future<void> setScaleMode(PAGScaleMode value) async {
    final api = await this.api.future;
    api.setScaleMode(value.api);
  }

  @override
  Future<void> stop() async {
    final api = await this.api.future;
    await api.stop().toDart;
  }
}
