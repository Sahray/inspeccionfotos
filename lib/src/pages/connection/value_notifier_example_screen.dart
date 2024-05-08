import 'package:app_inspections/main.dart';
import 'package:app_inspections/src/pages/connection/warning_widget_value_notifier.dart';
import 'package:app_inspections/src/pages/inicio_inspeccion.dart';
import 'package:flutter/material.dart';

class ValueNotifierExampleScreen extends StatelessWidget {
  const ValueNotifierExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Value notifier Example'),
      ),
      body: const Column(
        children: <Widget>[
          WarningWidgetValueNotifier(),
          InicioInspeccion(),
        ],
      ),
    );
  }
}
