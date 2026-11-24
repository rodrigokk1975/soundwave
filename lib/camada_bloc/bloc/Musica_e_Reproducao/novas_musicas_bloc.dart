import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/novas_musicas_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/novas_musicas_estado.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/song/obter_novas_musicas.dart';

class NovasMusicasBloc extends Bloc<NovasMusicasEvento, NovasMusicasEstado> {
  final ObterNovasMusicasCasoDeUso obterNovasMusicas;

  NovasMusicasBloc(this.obterNovasMusicas) : super(NovasMusicasInicial()) {
    on<CarregarNovasMusicas>(_aoCarregarNovasMusicas);
  }

  Future<void> _aoCarregarNovasMusicas(
    CarregarNovasMusicas evento,
    Emitter<NovasMusicasEstado> emit,
  ) async {
    emit(NovasMusicasCarregando());
    final resultado = await obterNovasMusicas.chamar();
    resultado.fold(
      (erro) => emit(NovasMusicasErro(erro)),
      (musicas) => emit(NovasMusicasCarregadas(musicas)),
    );
  }
}
