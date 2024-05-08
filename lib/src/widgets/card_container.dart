import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double paddingValue =
        screenWidth * 0.05; // 5% del ancho de la pantalla
    final double borderRadiusValue =
        screenWidth * 0.04; // 4% del ancho de la pantalla
    final double blurRadiusValue =
        screenWidth * 0.03; // 3% del ancho de la pantalla

    return Padding(
      padding: EdgeInsets.all(paddingValue),
      child: Container(
        width: double.infinity,
        decoration: _createCardShape(borderRadiusValue, blurRadiusValue),
        child: child,
      ),
    );
  }

  BoxDecoration _createCardShape(
      double borderRadiusValue, double blurRadiusValue) {
    return BoxDecoration(
      color: const Color.fromARGB(255, 251, 250, 250),
      borderRadius: BorderRadius.circular(borderRadiusValue),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: blurRadiusValue,
          offset: const Offset(0, 7),
        )
      ],
    );
  }
}
