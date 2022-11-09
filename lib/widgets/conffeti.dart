import 'dart:math';
import 'package:demo/repository/data_repository.dart';
import 'package:demo/screen/calculador.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';

class Conffeti extends StatefulWidget {
  late String descuento;
  late String desc;
  Conffeti({Key? key, required this.descuento, required this.desc})
      : super(key: key);
  @override
  _ConffetiState createState() => _ConffetiState();
}

class _ConffetiState extends State<Conffeti> {
  ConfettiController controller = ConfettiController();
  Repository repo = Repository();
  @override
  void initState() {
    super.initState();
    controller = ConfettiController(duration: const Duration(seconds: 2));
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: controller,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.yellow,
              Colors.green,
              Colors.orange,
              Colors.purple,
            ],
            //child: Center(child: Text('njjksjk')),
            shouldLoop: true,
            blastDirection: -pi / 2,
            //emissionFrequency: 0,
            numberOfParticles: 100,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¡Felicidades!',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 50,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                    Text(
                      'Ganaste un descuento del',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 20,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                    Text(
                      widget.descuento,
                      style: const TextStyle(
                          color: Colors.yellow,
                          fontSize: 50,
                          decoration: TextDecoration.none),
                    ),
                    Text(
                      widget.desc,
                      style: const TextStyle(
                          color: Colors.yellow,
                          fontSize: 50,
                          decoration: TextDecoration.none),
                    ),
                    GestureDetector(
                      onTap: () {
                        print(repo.user);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Calculador()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              'salir',
                              style: GoogleFonts.bebasNeue(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))),
          ),
        ),
      ],
    );
  }
}
