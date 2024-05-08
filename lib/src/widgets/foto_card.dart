import 'package:flutter/material.dart';

class FotoCard extends StatelessWidget {
  const FotoCard({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context)
        .size
        .width; // tamaño de la pantalla y ajusta tu diseño

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 30),
        width: screenWidth *
            0.9, // Utilizando un porcentaje del ancho de la pantalla
        height: 600,
        decoration: _cardBorders(),
        child: Stack(
          children: [
            _BackgroundImage(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(31, 208, 13, 13),
            offset: Offset(0, 7),
            blurRadius: 10,
          )
        ],
      );
}

class _BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: const SizedBox(
        width: double.infinity,
        height: 600,
        child: FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(
              'https://firebasestorage.googleapis.com/v0/b/app-inspecciones.appspot.com/o/Servicios%20maquila%2FCortadora%20l%C3%A1ser%2FIMG_6353.jpg?alt=media&token=c83b9e86-f6e0-46d1-9a49-6038d514acfd'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
