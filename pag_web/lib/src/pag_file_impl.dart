import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pag_platform_interface/pag_platform_interface.dart';

import 'js_interop.dart' as web;
import 'pag_composition_impl.dart';

final class PAGFileImpl extends PAGFile with PAGCompositionImpl {
  @override
  final FutureOr<web.PAGFile> api;

  PAGFileImpl(this.api) : super.impl();

  /// 按资源名加载：先通过 rootBundle 读取字节，再转 ArrayBuffer 交给
  /// JS 侧 PAGFile.load（其仅接受 File/Blob/ArrayBuffer，字符串会报
  /// "Initialize PAGFile data type error"）。
  PAGFileImpl.asset(String asset)
    : api = web.libPAG.then((libPAG) async {
        final data = await rootBundle.load(asset);
        return libPAG.PAGFile.load(data.buffer.toJS).toDart;
      }),
      super.impl();

  /// Web 端无本地文件路径概念，将 file 视为 URL 用 fetch 加载。
  PAGFileImpl.file(String file)
    : api = web.libPAG.then((libPAG) async {
        final response = await web.fetch(file).toDart;
        if (!response.ok) {
          throw StateError('Failed to load $file: HTTP ${response.status}');
        }
        final buffer = await response.arrayBuffer().toDart;
        return libPAG.PAGFile.load(buffer).toDart;
      }),
      super.impl();

  /// 字节数组构造：需转成 ArrayBuffer 而非 Uint8Array（后者不在
  /// PAGFile.load 接受的类型列表中）。
  PAGFileImpl.bytes(Uint8List bytes)
    : api = web.libPAG.then(
        (libPAG) => libPAG.PAGFile.load(bytes.buffer.toJS).toDart,
      ),
      super.impl();
}
