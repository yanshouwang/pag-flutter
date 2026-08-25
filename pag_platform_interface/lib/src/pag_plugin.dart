import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pag_composition.dart';
import 'pag_file.dart';
import 'pag_scale_mode.dart';
import 'pag_view.dart';

abstract base class PAGPlugin extends PlatformInterface {
  /// Constructs a PAGPlugin.
  PAGPlugin() : super(token: _token);

  static final Object _token = Object();

  static PAGPlugin? _instance;

  /// The default instance of [PAGPlugin] to use.
  static PAGPlugin get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
        'PAGPlugin is not implemented on this platform.',
      );
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PAGPlugin] when
  /// they register themselves.
  static set instance(PAGPlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  PAGFile newPAGFileWithAsset(String asset);
  PAGFile newPAGFileWithFile(String file);
  PAGFile newPAGFileWithBytes(Uint8List bytes);
  PAGView newPAGView({
    required PAGComposition composition,
    PAGScaleMode? scaleMode,
    int? repeatCount,
    double? progress,
  });
  Widget newPAGWidget(PAGView view);
}
