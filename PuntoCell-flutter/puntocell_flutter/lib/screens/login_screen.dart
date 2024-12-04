import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 20),
                    child: Image.asset(
                      'assets/logopuntocell.png',
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),
                const Text(
                  "Manejo de inventario",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF525B44), fontSize: 25),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 50),
                  child: const TextField(
                    style: TextStyle(color: Color(0xFF525B44)),
                    decoration: InputDecoration(
                      label: Text(
                        'Usuario o correo electrónico',
                        style: TextStyle(color: Color(0xFF525B44)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF039443)),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF039443)),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
                  child: const TextField(
                    style: TextStyle(color: Color(0xFF525B44)),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      label: Text(
                        'Contraseña',
                        style: TextStyle(color: Color(0xFF525B44)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF039443)),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF039443)),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (keyboardHeight == 0)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Continuar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
