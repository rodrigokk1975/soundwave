import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/obter_usuario.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/info_perfil_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/info_perfil_estado.dart';

class InfoPerfilBloc extends Bloc<InfoPerfilEvento, InfoPerfilEstado> {
  final ObterUsuarioCasoDeUso obterUsuarioCasoDeUso;

  InfoPerfilBloc({required this.obterUsuarioCasoDeUso})
    : super(InfoPerfilCarregando()) {
    on<InfoPerfilRequisicaoEvento>(_aoRequisitarInfoPerfil);
  }

  Future<void> _aoRequisitarInfoPerfil(
    InfoPerfilRequisicaoEvento evento,
    Emitter<InfoPerfilEstado> emit,
  ) async {
    emit(InfoPerfilCarregando());

    var usuario = await obterUsuarioCasoDeUso.chamar();

    usuario.fold(
      (falha) {
        emit(InfoPerfilFalha());
      },
      (entidadeUsuario) {
        emit(InfoPerfilCarregado(entidadeUsuario: entidadeUsuario));
      },
    );
  }
}
