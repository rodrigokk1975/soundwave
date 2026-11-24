import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/favoritos_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/favoritos_estado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:project_sound_wave/camada_dados/dominio/usecases/song/adicionar_ou_remover_musica_favorita.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/song/obter_musicas_favoritas.dart';

class FavoritosBloc extends Bloc<FavoritosEvento, FavoritosEstado> {
  final AdicionarOuRemoverMusicaFavoritaCasoDeUso adicionarOuRemoverFavorita;

  final ObterMusicasFavoritasCasoDeUso obterFavoritas;

  FavoritosBloc({
    required this.adicionarOuRemoverFavorita,
    required this.obterFavoritas,
  }) : super(FavoritosInicial()) {
    on<CarregarFavoritos>(_aoCarregarFavoritos);
    on<AlternarFavorito>(_aoAlternarFavorito);
  }

  Future<void> _aoAlternarFavorito(
    AlternarFavorito evento,
    Emitter<FavoritosEstado> emit,
  ) async {
    emit(FavoritosCarregando());
    try {
      final resultado = await adicionarOuRemoverFavorita.chamar(
        parametros: evento.idMusica,
      );

      resultado.fold((erro) => emit(FavoritosErro(erro)), (eFavorito) {
        add(CarregarFavoritos());
      });
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(FavoritosErro('Usuário não autenticado.'));
      } else if (e is SocketException) {
        emit(FavoritosErro('Sem conexão com a internet.'));
      } else {
        emit(FavoritosErro(e.toString()));
      }
    }
  }

  Future<void> _aoCarregarFavoritos(
    CarregarFavoritos evento,
    Emitter<FavoritosEstado> emit,
  ) async {
    emit(FavoritosCarregando());
    final resultado = await obterFavoritas.chamar();
    resultado.fold(
      (erro) => emit(FavoritosErro(erro)),
      (musicas) => emit(FavoritosCarregados(musicas)),
    );
  }
}
