import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pag_platform_interface/pag_platform_interface.dart';

import 'pag_file_impl.dart';
import 'pag_view_impl.dart';

const kPAGViewType = 'zeekr.dev/PAGView';

abstract final class PAGDarwinPlugin extends PAGPlugin {
  @override
  PAGFile newPAGFileWithAsset(String asset) {
    return PAGFileImpl.asset(asset);
  }

  @override
  PAGFile newPAGFileWithFile(String file) {
    return PAGFileImpl.file(file);
  }

  @override
  PAGFile newPAGFileWithBytes(Uint8List bytes) {
    return PAGFileImpl.bytes(bytes);
  }

  @override
  PAGView newPAGView({
    required PAGComposition composition,
    PAGScaleMode? scaleMode,
    int? repeatCount,
    double? progress,
  }) {
    return PAGViewImpl();
  }
}

final class PAGiOSPlugin extends PAGDarwinPlugin {
  static void registerWith() {
    PAGPlugin.instance = PAGiOSPlugin();
  }

  @override
  Widget newPAGWidget(PAGView view) {
    final identifier = view.api.pigeon_instanceManager.getIdentifier(view.api);
    return UiKitView(
      viewType: kPAGViewType,
      layoutDirection: TextDirection.ltr,
      creationParams: identifier,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}

final class PAGmacOSPlugin extends PAGDarwinPlugin {
  static void registerWith() {
    PAGPlugin.instance = PAGmacOSPlugin();
  }

  @override
  Widget newPAGWidget(PAGView view) {
    final identifier = view.api.pigeon_instanceManager.getIdentifier(view.api);
    return AppKitView(
      viewType: kPAGViewType,
      layoutDirection: TextDirection.ltr,
      creationParams: identifier,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
