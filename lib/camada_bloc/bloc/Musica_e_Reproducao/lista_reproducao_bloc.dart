import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/lista_reproducao_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/lista_reproducao_estado.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/song/adicionar_ou_remover_musica_favorita.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/song/obter_lista_reproducao.dart';

class ListaReproducaoBloc
    extends Bloc<ListaReproducaoEvento, ListaReproducaoEstado> {
  final ObterListaReproducaoCasoDeUso obterListaReproducao;

  final AdicionarOuRemoverMusicaFavoritaCasoDeUso adicionarOuRemoverFavorita;

  ListaReproducaoBloc({
    required this.obterListaReproducao,
    required this.adicionarOuRemoverFavorita,
  }) : super(ListaReproducaoInicial()) {
    on<CarregarListaReproducao>(_aoCarregarListaReproducao);
    on<AlternarMusicaFavorita>(_aoAlternarFavorito);
  }

  Future<void> _aoCarregarListaReproducao(
    CarregarListaReproducao evento,
    Emitter<ListaReproducaoEstado> emit,
  ) async {
    emit(ListaReproducaoCarregando());
    final resultado = await obterListaReproducao.chamar();
    resultado.fold(
      (erro) => emit(ListaReproducaoErro(erro)),
      (musicas) => emit(ListaReproducaoCarregada(musicas)),
    );
  }

  Future<void> _aoAlternarFavorito(
    AlternarMusicaFavorita evento,
    Emitter<ListaReproducaoEstado> emit,
  ) async {
    final resultado = await adicionarOuRemoverFavorita.chamar(
      parametros: evento.idMusica,
    );
    resultado.fold(
      (erro) => emit(ListaReproducaoErro(erro)),
      (eFavorito) => emit(FavoritoAlternado(eFavorito)),
    );
  }
}
