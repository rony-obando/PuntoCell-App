import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/providers/dashboard.provider.dart';
import 'package:puntocell_flutter/providers/home_provider.dart';
import 'package:puntocell_flutter/providers/producto_provider.dart';
import 'package:puntocell_flutter/providers/venta_provider.dart';
import 'package:puntocell_flutter/repository/producto_repository.dart';
import 'package:puntocell_flutter/repository/venta_repository.dart';
import 'package:puntocell_flutter/screens/dashboard_screen.dart';
import 'package:puntocell_flutter/screens/home_screen.dart';
import 'package:puntocell_flutter/screens/login_screen.dart';
import 'package:puntocell_flutter/screens/productos_screen.dart';
import 'package:puntocell_flutter/screens/venta_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_size/window_size.dart' as window_size;




void main() async{
  await dotenv.load(fileName: "assets/keys.env");
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('es', null);
  Intl.defaultLocale = 'es';
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    window_size.setWindowTitle('PuntoCell App');
    window_size.setWindowMinSize(const Size(800, 800));
    window_size.setWindowMaxSize(const Size(1920, 1080));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductoRepository productoRepository = ProductoRepository();
    final VentaRepository ventaRepository = VentaRepository();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductoProvider(productoRepository:productoRepository)),
        ChangeNotifierProvider(create: (_) => VentaProvider(ventaRepository: ventaRepository)),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider(productoRepository: productoRepository, ventaRepository: ventaRepository))
      ],
      builder: (context, _) {
        return MaterialApp(
          localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''), // Español
        Locale('en', ''), // Inglés
      ],
          debugShowCheckedModeBanner: false,
          title: 'PuntoCellApp',
          theme: ThemeData(
            
            fontFamily: 'Onest',
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF039443)),
            scaffoldBackgroundColor: const Color(0xFFEFEFEF),
            useMaterial3: true,
          ),
          initialRoute: 'Login',
          routes: {
            'Login': (_) => const LoginScreen(),
            'Home': (_) => const HomeScreen(),
            'Productos': (_) => ProductoScreen(),
            'Ventas': (_) => const VentaScreen(),
            'Dashboard': (_) => const DashboardScreen(),
          },
        );
      },
    );
  }
}
