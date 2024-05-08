import 'package:app_inspections/models/mano_obra.dart';
import 'package:app_inspections/models/materiales.dart';
import 'package:app_inspections/models/problemas.dart';
import 'package:app_inspections/models/reporte_model.dart';
import 'package:app_inspections/models/tiendas.dart';
import 'package:app_inspections/models/usuarios.dart';
import 'package:app_inspections/services/auth_service.dart';
import 'package:app_inspections/services/db_offline.dart';
import 'package:app_inspections/services/db_online.dart';
import 'package:app_inspections/src/pages/agregarDefectos.dart';
import 'package:app_inspections/src/pages/f1.dart';
import 'package:app_inspections/src/pages/inicio_indv.dart';
import 'package:app_inspections/src/pages/screens.dart';
import 'package:app_inspections/src/pages/users.dart';
import 'package:app_inspections/src/pages/utils/check_internet_connection.dart';
import 'package:app_inspections/src/screens/home_foto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final internetChecker = CheckInternetConnection();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //inicializa bd online
  DatabaseHelper dbHelper;

  // Llama a la función para insertar los datos iniciales de materiales
  insertInitialDataM();
  //llamar a la funcion para insertar datos iniciales de problemas
  insertInitialDataP();
  //llamar a la funcion para insertar datos iniciales de mano de obra
  insertInitialDataO();
  //llamar a la funcion para inserta r datos iniciales de tiendas
  insertInitialDataT();
  //llamar a la funcion para insertar datos iniciales de usuarios
  insertInitialDataUser();

  dbHelper = DatabaseHelper();

  runApp(AppState(
    dbHelper: dbHelper,
  ));

  // Suscribe para recibir actualizaciones sobre el estado de la conexión

  internetChecker.internetStatus().listen((status) async {
    print('Estado de conexión actualizado: $status');
    // Aquí puedes manejar la lógica basada en el estado de la conexión
    // Por ejemplo, puedes llamar a la función de sincronización con PostgreSQL si el estado es online
    if (status == ConnectionStatus.online) {
      // Supongamos que tienes un futuro que resuelve en una lista de reportes
      Future<List<Reporte>> futuroReportes =
          DatabaseProvider.leerReportesDesdeSQLite();

      // Espera el futuro para obtener la lista de reportes
      List<Reporte> listaReportes = await futuroReportes;
      // Aquí puedes llamar a tu función para sincronizar con PostgreSQL

      await DatabaseHelper.sincronizarConPostgreSQL(listaReportes);
    }
  });

  return;
}

class NotificationsServices {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static void init() {}
}

class AppState extends StatelessWidget {
  final DatabaseHelper dbHelper;

  const AppState({required this.dbHelper, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "inicioInsp",
      routes: {
        "splash": (_) => const SplashScreen(),
        "registro": (_) => const RegistroScreen(),
        "login": (_) => const LoginScreen(),
        "inicioInsp": (_) => const InicioInspeccion(),
        "inspectienda": (_) => const InspeccionTienda(initialTabIndex: 0),
        "f1": (_) => const F1Screen(idTienda: 1),
        "inicio": (_) =>
            const InicioScreen(idTienda: 1, initialTabIndex: 0, nomTienda: ''),
        "home": (_) => const HomeFoto(),
        "user": (_) => const UserInsertion(),
        /*"prueba": (_) => const FormPrincipal(
          
              idTienda: 1,
            ),*/
        "defectos": (_) => Defectos(),
      },
      scaffoldMessengerKey: NotificationsServices.messengerKey,
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255)),
    );
  }
}
