import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: const Color.fromRGBO(241, 240, 241, 1),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.5,
            child: _PurpleBox(),
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: _HeaderIcon(),
          ),
          Positioned.fill(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
          top: size.height * 0.05), // Ajusta este valor según sea necesario
      child: Center(
        child: Image.asset(
          'assets/logo.png',
          height: size.height *
              0.2, // Tamaño del logo como un porcentaje de la altura de la pantalla
        ),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/prueba.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
