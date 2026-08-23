import 'dart:async';
import 'dart:js_interop';

import 'package:pag_platform_interface/pag_platform_interface.dart';

import 'js_interop.dart' as js;
import 'pag_file_impl.dart';

base mixin PAGCompositionImpl on PAGComposition {
  FutureOr<js.PAGComposition> get api;

  @override
  Future<int> getWidth() async {
    final api = await this.api;
    final value = api.width().toInt();
    return value;
  }

  @override
  Future<int> getHeight() async {
    final api = await this.api;
    final value = api.height().toInt();
    return value;
  }
}

extension PAGCompositionX on PAGComposition {
  FutureOr<js.PAGComposition> get api {
    final impl = this;
    if (impl is! PAGCompositionImpl) {
      throw TypeError();
    }
    return impl.api;
  }
}

extension JsPAGCompositionX on js.PAGComposition {
  PAGComposition get impl {
    final api = this;
    final isPAGFile = api.isA<js.PAGFile>();
    if (!isPAGFile) {
      throw TypeError();
    }
    return PAGFileImpl(api as js.PAGFile);
  }
}
