import 'dart:convert';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:demo/models/user.dart';
import 'package:demo/repository/data_repository.dart';
import 'package:demo/widgets/conffeti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class Spinning extends StatefulWidget {
  final int genero;
  final int edad;
  final bool beneficios;
  final String captacion;
  final int valoracion;
  Spinning(
      {Key? key,
      required this.edad,
      required this.genero,
      required this.beneficios,
      required this.captacion,
      required this.valoracion})
      : super(key: key);

  @override
  _SpinningState createState() => _SpinningState();
}

class _SpinningState extends State<Spinning> {
  final uri = Uri.parse(
      'https://enersisuat.azurewebsites.net/api/Promocion/DinamicaRuleta');
  List<CameraDescription> _cameras = [];
  final String desc = 'vacío';
  String imagen = '';
  double dato = 0.0;
  XFile? imageFile;
  Repository repo = Repository();
  late CameraController _controller;
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();
  final selected = BehaviorSubject<int>();
  String rewards = '';
  int count = 1;
  List<int> items = [
    21,
    22,
    22,
    22,
    23,
    22,
    21,
    22,
    24,
    22,
    21,
    23,
    21,
    24,
    21,
    25,
    21,
    23,
    26,
    22,
    21,
    22,
    27,
    22,
    21,
    22,
    28,
    22,
    21,
    29,
    22,
    21,
    30
  ];

  @override
  void initState() {
    initializeCamera();
    super.initState();
  }

  @override
  void dispose() {
    selected.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 280, bottom: 100),
                child: Text(
                  'Intentos: $count',
                  style:
                      GoogleFonts.bebasNeue(fontSize: 20, color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  'Gira y gana',
                  style:
                      GoogleFonts.bebasNeue(fontSize: 50, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 500,
                width: MediaQuery.of(context).size.width - 15,
                child: FortuneWheel(
                  physics: CircularPanPhysics(
                      curve: Curves.easeInOutCubicEmphasized,
                      duration: const Duration(seconds: 3)),
                  indicators: const <FortuneIndicator>[
                    FortuneIndicator(
                        alignment: Alignment.topCenter,
                        child: TriangleIndicator(
                          color: Colors.yellow,
                        ))
                  ],
                  selected: selected.stream,
                  animateFirst: false,
                  items: [
                    for (int i = 0; i < items.length; i++) ...<FortuneItem>{
                      FortuneItem(
                          child: Text(
                            '${items[i]}%',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          style: const FortuneItemStyle(
                              color: Color.fromARGB(255, 0, 140, 255),
                              borderColor: Colors.black,
                              borderWidth: 3)),
                    },
                  ],
                  onAnimationEnd: () {
                    log(imagen);
                    setState(() {
                      rewards = '${items[selected.value]}%';
                      dato = items[selected.value] / 100;
                    });
                    if (validar()) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Conffeti(
                                    descuento: rewards,
                                    desc: desc,
                                  )),
                          (route) => false);
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  takePicturex();
                  setState(() {
                    count--;
                    selected.add(Fortune.randomInt(0, items.length));
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red),
                  height: 40,
                  width: 120,
                  //color: Colors.redAccent,
                  child: Center(
                    child: Text(
                      "Girar",
                      style: GoogleFonts.bebasNeue(
                          fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validar() {
    if (rewards == ':C') {
      Alert(
        context: context,
        style: const AlertStyle(isCloseButton: false),
        buttons: [
          DialogButton(
              color: Colors.black,
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context))
        ],
        title: "Qué mal...",
        desc: "Suerte para la próxima",
        image: Image.asset(
          'assets/triste.png',
          height: 100,
        ),
      ).show();
      return false;
    }
    return true;
  }

  register() async {
    var model = Usuario(
        genero: widget.genero,
        beneficios: widget.beneficios,
        canal: widget.captacion,
        desc: dato,
        edad: widget.edad,
        foto: imagen,
        valoracion: widget.valoracion);
    await repo.register(model);
  }

  // bool attemps() {
  //   if (count == 0) {
  //     Alert(
  //       context: context,
  //       style: const AlertStyle(isCloseButton: false),
  //       buttons: [
  //         DialogButton(
  //             color: Colors.black,
  //             child: const Text(
  //               "OK",
  //               style: TextStyle(color: Colors.white, fontSize: 20),
  //             ),
  //             onPressed: () => Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => const HomePage()),
  //                 (route) => false))
  //       ],
  //       title: "Lo siento...",
  //       desc: "Ya no te quedan intentos",
  //       image: Image.asset(
  //         'assets/triste.png',
  //         height: 100,
  //       ),
  //     ).show();

  //     return false;
  //   }
  //   return true;
  // }

  initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[1], ResolutionPreset.max);
    await _controller.initialize();
    setState(() {});
  }

  takePicturex() async {
    XFile xfile = await _controller.takePicture();
    log(xfile.path);
    Uint8List imagebytes = await xfile.readAsBytes();
    setState(() {
      imagen = base64.encode(imagebytes);
    });
    log(imagen);
  }
}
