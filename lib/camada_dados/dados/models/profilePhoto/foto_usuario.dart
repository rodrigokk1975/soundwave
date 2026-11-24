import 'package:project_sound_wave/camada_dados/dominio/entities/profilePhoto/foto_usuario.dart';

class FotoPerfilModelo {
  final String name;
  final String imageURL;

  FotoPerfilModelo({required this.name, required this.imageURL});

  factory FotoPerfilModelo.fromJson(Map<String, dynamic> json) {
    return FotoPerfilModelo(
      name: json['name'] ?? '',
      imageURL: json['imageURL'] ?? '',
    );
  }

  FotoPerfilEntidade toEntity() {
    return FotoPerfilEntidade(name: name, imageURL: imageURL);
  }
}
