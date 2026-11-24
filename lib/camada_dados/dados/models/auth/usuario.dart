import 'package:project_sound_wave/camada_dados/dominio/entities/auth/usuario.dart';

class UsuarioModelo {
  final String nomeCompleto;
  final String email;
  final String? urlImagem;

  UsuarioModelo({
    required this.nomeCompleto,
    required this.email,
    this.urlImagem,
  });

  factory UsuarioModelo.fromJson(Map<String, dynamic> data) {
    return UsuarioModelo(
      nomeCompleto: data['name'] ?? '',
      email: data['email'] ?? '',
      urlImagem: data['imageURL'],
    );
  }

  UsuarioEntidade converterModeloParaEntidade() {
    return UsuarioEntidade(
      nomeCompleto: nomeCompleto,
      email: email,
      urlImagem: urlImagem,
    );
  }
}
