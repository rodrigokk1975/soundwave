import 'package:project_sound_wave/camada_dados/dominio/entities/profilePhoto/foto_usuario.dart';

abstract class BuscarFotosPerfilEstado {}

class BuscarFotosPerfilCarregando extends BuscarFotosPerfilEstado {}

class BuscarFotosPerfilCarregado extends BuscarFotosPerfilEstado {
  final List<FotoPerfilEntidade> fotos;

  BuscarFotosPerfilCarregado({required this.fotos});
}

class BuscarFotosPerfilFalha extends BuscarFotosPerfilEstado {}
