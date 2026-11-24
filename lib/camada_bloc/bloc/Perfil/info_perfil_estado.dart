import 'package:project_sound_wave/camada_dados/dominio/entities/auth/usuario.dart';

abstract class InfoPerfilEstado {}

class InfoPerfilCarregando extends InfoPerfilEstado {}

class InfoPerfilCarregado extends InfoPerfilEstado {
  final UsuarioEntidade entidadeUsuario;
  InfoPerfilCarregado({required this.entidadeUsuario});
}

class InfoPerfilFalha extends InfoPerfilEstado {}
