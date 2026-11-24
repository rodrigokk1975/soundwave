import 'package:cloud_firestore/cloud_firestore.dart';

class MusicaEntidade {
  final String titulo;
  final String artista;
  final num duracao;
  final Timestamp dataDeLancamento;
  final bool favorita;
  final String idMusica;
  final String urlCapa;
  final String urlMusica;

  MusicaEntidade({
    required this.titulo,
    required this.artista,
    required this.duracao,
    required this.dataDeLancamento,
    required this.favorita,
    required this.idMusica,
    required this.urlCapa,
    required this.urlMusica,
  });
}
