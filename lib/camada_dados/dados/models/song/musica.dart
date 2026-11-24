import 'package:project_sound_wave/camada_dados/dominio/entities/song/musica.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MusicaModelo {
  String? titulo;
  String? artista;
  num? duracao;
  Timestamp? dataLancamento;
  bool? favorita;
  String? idMusica;
  String? urlCapa;
  String? urlMusica;

  MusicaModelo({
    required this.titulo,
    required this.artista,
    required this.duracao,
    required this.dataLancamento,
    required this.favorita,
    required this.idMusica,
    required this.urlCapa,
    required this.urlMusica,
  });

  MusicaModelo.fromJson(Map<String, dynamic> data) {
    titulo = data['title'];
    artista = data['artist'];
    duracao = data['duration'];
    dataLancamento = data['releaseDate'];
    urlCapa = data['coverURL'];
    urlMusica = data['songURL'];
  }

  MusicaEntidade converterModeloParaEntidade() {
    return MusicaEntidade(
      titulo: titulo ?? '',
      artista: artista ?? '',
      duracao: duracao ?? 0,
      dataDeLancamento: dataLancamento ?? Timestamp.now(),
      favorita: favorita ?? false,
      idMusica: idMusica ?? '',
      urlCapa: urlCapa ?? '',
      urlMusica: urlMusica ?? '',
    );
  }
}
