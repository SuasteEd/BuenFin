import 'package:demo/models/user.dart';
import 'package:get/get.dart';

class Repository extends GetxController{
  final user = <Usuario>[].obs;

  register(Usuario newUsuario) {
    //Método para guardar
    user.add(newUsuario);
  }
}
