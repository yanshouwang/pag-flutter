import 'package:flutter/widgets.dart';
import 'package:pag_platform_interface/pag_platform_interface.dart';

import 'pag_controller.dart';

class PAGWidget extends StatelessWidget {
  final PAGController controller;
  const PAGWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PAGPlugin.instance.newPAGWidget(controller.view);
  }
}
