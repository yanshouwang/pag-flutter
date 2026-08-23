import 'dart:typed_data';
import 'dart:ui_web' as web;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:pag_platform_interface/pag_platform_interface.dart';
import 'package:web/web.dart' as web;

import 'pag_file_impl.dart';
import 'pag_view_impl.dart';

final class PAGWebPlugin extends PAGPlugin {
  static void registerWith(Registrar registrar) {
    PAGPlugin.instance = PAGWebPlugin();
    web.platformViewRegistry.registerViewFactory(
      kPAGViewType,
      (int viewId, {Object? args}) => web.HTMLCanvasElement()
        ..id = '$viewId'
        ..style.width = '100%'
        ..style.height = '100%',
    );
  }

  @override
  PAGFile newPAGAsset(String asset) => PAGFileImpl.asset(asset);

  @override
  PAGFile newPAGFile(String file) => PAGFileImpl.file(file);

  @override
  PAGFile newPAGBytes(Uint8List bytes) => PAGFileImpl.bytes(bytes);

  @override
  PAGView newPAGView() => PAGViewImpl();
}
