import 'package:flutter/material.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SizedBox(
          child: AppBar(
            backgroundColor: const Color.fromRGBO(6, 6, 68, 1),
            title: const Text(
              "Inspecciones Conexsa",
              style: TextStyle(fontSize: 28.0, color: Colors.white),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No hay conexión a Internet. Por favor, revisa tu conexión.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.0, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Image.asset(
              'assets/internet.gif',
              width: 800,
              height: 800,
            ),
          ],
        ),
      ),
    );
  }
}
