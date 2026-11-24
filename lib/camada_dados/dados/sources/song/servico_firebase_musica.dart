import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_sound_wave/camada_dados/dados/models/song/musica.dart';
import 'package:project_sound_wave/camada_dados/dominio/entities/song/musica.dart';

abstract class ServicoFirebaseMusica {
  Future<Either> buscarMusicasNovas();
  Future<Either> buscarPlaylists();
  Future<Either> adicionarOuRemoverFavorita(String idMusica);
  Future<bool> verificarSeMusicaFavorita(String idMusica);
  Future<Either> buscarMusicasFavoritasDoUsuario();
}

class ImplementacaoDosServicosFirebaseMusica extends ServicoFirebaseMusica {
  Future<Set<String>> _buscarIdsMusicasFavoritas() async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return {};

    final favoritosSnapshot =
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(usuario.uid)
            .collection('Favorites')
            .get();

    return favoritosSnapshot.docs
        .map((doc) => doc.data()['songId'])
        .whereType<String>()
        .toSet();
  }

  @override
  Future<Either> buscarMusicasNovas() async {
    try {
      List<MusicaEntidade> musicas = [];

      final bancoDeDados = FirebaseFirestore.instance;
      final colecaoMusicas = bancoDeDados.collection('Songs');
      final consultaOrdenada = colecaoMusicas
          .orderBy('releaseDate', descending: true)
          .limit(5);
      final resultado = await consultaOrdenada.get();
      final idsFavoritas = await _buscarIdsMusicasFavoritas();

      for (var doc in resultado.docs) {
        var modeloMusica = MusicaModelo.fromJson(doc.data());
        modeloMusica.favorita = idsFavoritas.contains(doc.reference.id);
        modeloMusica.idMusica = doc.reference.id;
        musicas.add(modeloMusica.converterModeloParaEntidade());
      }

      return Right(musicas);
    } catch (e) {
      return const Left(
        'Ocorreu um erro ao buscar músicas novas. Tente novamente.',
      );
    }
  }

  @override
  Future<Either> buscarPlaylists() async {
    try {
      List<MusicaEntidade> musicas = [];

      final bancoDeDados = FirebaseFirestore.instance;
      final colecaoMusicas = bancoDeDados.collection('Songs');
      final consultaOrdenada = colecaoMusicas.orderBy('title');
      final resultado = await consultaOrdenada.get();
      final idsFavoritas = await _buscarIdsMusicasFavoritas();

      for (var doc in resultado.docs) {
        var modeloMusica = MusicaModelo.fromJson(doc.data());
        modeloMusica.favorita = idsFavoritas.contains(doc.reference.id);
        modeloMusica.idMusica = doc.reference.id;
        musicas.add(modeloMusica.converterModeloParaEntidade());
      }

      return Right(musicas);
    } catch (e) {
      return const Left(
        'Ocorreu um erro ao buscar a playlist. Tente novamente.',
      );
    }
  }

  @override
  Future<Either> adicionarOuRemoverFavorita(String idMusica) async {
    try {
      final autenticacao = FirebaseAuth.instance;
      final banco = FirebaseFirestore.instance;

      var usuario = autenticacao.currentUser;
      String idUsuario = usuario!.uid;

      var favoritos =
          await banco
              .collection('Users')
              .doc(idUsuario)
              .collection('Favorites')
              .where('songId', isEqualTo: idMusica)
              .get();

      bool favorita;
      if (favoritos.docs.isNotEmpty) {
        await favoritos.docs.first.reference.delete();
        favorita = false;
      } else {
        await banco
            .collection('Users')
            .doc(idUsuario)
            .collection('Favorites')
            .add({'songId': idMusica});
        favorita = true;
      }

      return Right(favorita);
    } catch (e) {
      return const Left(
        'Ocorreu um erro ao atualizar favorito. Tente novamente.',
      );
    }
  }

  @override
  Future<bool> verificarSeMusicaFavorita(String idMusica) async {
    try {
      final autenticacao = FirebaseAuth.instance;
      final banco = FirebaseFirestore.instance;
      var usuario = autenticacao.currentUser;
      String idUsuario = usuario!.uid;

      var favoritos =
          await banco
              .collection('Users')
              .doc(idUsuario)
              .collection('Favorites')
              .where('songId', isEqualTo: idMusica)
              .get();

      return favoritos.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> buscarMusicasFavoritasDoUsuario() async {
    try {
      final autenticacao = FirebaseAuth.instance;
      final banco = FirebaseFirestore.instance;
      var usuario = autenticacao.currentUser;
      List<MusicaEntidade> musicasFavoritas = [];
      String idUsuario = usuario!.uid;

      var favoritosSnapshot =
          await banco
              .collection('Users')
              .doc(idUsuario)
              .collection('Favorites')
              .get();

      for (var docFavorito in favoritosSnapshot.docs) {
        String idMusica = docFavorito['songId'];
        var musicaDoc = await banco.collection('Songs').doc(idMusica).get();
        MusicaModelo modeloMusica = MusicaModelo.fromJson(musicaDoc.data()!);
        modeloMusica.favorita = true;
        modeloMusica.idMusica = idMusica;
        musicasFavoritas.add(modeloMusica.converterModeloParaEntidade());
      }

      return Right(musicasFavoritas);
    } catch (e) {
      return const Left('Ocorreu um erro ao buscar músicas favoritas.');
    }
  }
}
