import 'package:pag_platform_interface/pag_platform_interface.dart';

import 'api.g.dart';
import 'pag_file_impl.dart';

extension PAGScaleModeX on PAGScaleMode {
  PAGScaleModeApi get api => PAGScaleModeApi.values[index];
}

extension PAGScaleModeApiX on PAGScaleModeApi {
  PAGScaleMode get impl => PAGScaleMode.values[index];
}

extension PAGCompositionX on PAGComposition {
  PAGCompositionApi get api {
    final impl = this;
    if (impl is! PAGFileImpl) {
      throw TypeError();
    }
    return impl.api;
  }
}

extension PAGCompositionApiX on PAGCompositionApi {
  PAGComposition get impl {
    final api = this;
    if (api is! PAGFileApi) {
      throw TypeError();
    }
    return PAGFileImpl(api);
  }
}
