import 'dart:typed_data';
import 'dart:ui_web' as web;

import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:pag_platform_interface/pag_platform_interface.dart';
import 'package:web/web.dart' as web;

import 'pag_file_impl.dart';
import 'pag_view_impl.dart';

const kPAGViewType = 'zeekr.dev/PAGView';

final class PAGWebPlugin extends PAGPlugin {
  static void registerWith(Registrar registrar) {
    PAGPlugin.instance = PAGWebPlugin();
    web.platformViewRegistry.registerViewFactory(
      kPAGViewType,
      (int viewId, {Object? args}) => web.HTMLCanvasElement()
        ..style.width = '100%'
        ..style.height = '100%',
    );
  }

  @override
  PAGFile newPAGFileWithAsset(String asset) => PAGFileImpl.asset(asset);

  @override
  PAGFile newPAGFileWithFile(String file) => PAGFileImpl.file(file);

  @override
  PAGFile newPAGFileWithBytes(Uint8List bytes) => PAGFileImpl.bytes(bytes);

  @override
  PAGView newPAGView({
    required PAGComposition composition,
    PAGScaleMode? scaleMode,
    int? repeatCount,
    double? progress,
  }) => PAGViewImpl(
    composition: composition,
    scaleMode: scaleMode,
    repeatCount: repeatCount,
    progress: progress,
  );

  @override
  Widget newPAGWidget(PAGView view) {
    return HtmlElementView(
      viewType: kPAGViewType,
      onPlatformViewCreated: (viewId) {
        debugPrint('onPlatformViewCreated: $viewId');
      },
      creationParams: {'element': view.canvas},
    );
  }
}
