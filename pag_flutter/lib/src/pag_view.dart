import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pag_flutter/src/pag_composition.dart';
import 'package:pag_platform_interface/pag_platform_interface.dart' as i;

import 'pag_controller.dart';
import 'pag_file.dart';
import 'pag_scale_mode.dart';

const _kRepeatCount = 0;
const _kScaleMode = i.PAGScaleMode.letterBox;
const _kProgress = 0.0;

class PAGView extends StatefulWidget {
  final PAGController controller;
  final PAGFile file;
  final int repeatCount;
  final PAGScaleMode scaleMode;
  final double progress;

  PAGView.asset(
    String asset, {
    required this.controller,
    this.repeatCount = _kRepeatCount,
    this.scaleMode = _kScaleMode,
    this.progress = _kProgress,
    super.key,
  }) : file = PAGFile.asset(asset);

  PAGView.file(
    String file, {
    required this.controller,
    this.repeatCount = _kRepeatCount,
    this.scaleMode = _kScaleMode,
    this.progress = _kProgress,
    super.key,
  }) : file = PAGFile.file(file);

  PAGView.bytes(
    Uint8List bytes, {
    required this.controller,
    this.repeatCount = _kRepeatCount,
    this.scaleMode = _kScaleMode,
    this.progress = _kProgress,
    super.key,
  }) : file = PAGFile.bytes(bytes);

  @override
  State<PAGView> createState() => _PAGViewState();
}

class _PAGViewState extends State<PAGView> {
  i.PAGView get api => widget.controller.api;

  @override
  void initState() {
    super.initState();
    api
      ..setCompositon(widget.file.api)
      ..setRepeatCount(widget.repeatCount)
      ..setScaleMode(widget.scaleMode)
      ..setProgress(widget.progress);
  }

  @override
  Widget build(BuildContext context) {
    return api.build(context);
  }

  @override
  void didUpdateWidget(covariant PAGView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.file != oldWidget.file) {
      api.setCompositon(widget.file.api);
    }
    if (widget.repeatCount != oldWidget.repeatCount) {
      api.setRepeatCount(widget.repeatCount);
    }
    if (widget.scaleMode != oldWidget.scaleMode) {
      api.setScaleMode(widget.scaleMode);
    }
    if (widget.progress != oldWidget.progress) {
      api.setProgress(widget.progress);
    }
  }
}
