import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/editar_usuario.dart';
import 'editar_perfil_eventos.dart';
import 'editar_perfil_estado.dart';

class EditarPerfilBloc extends Bloc<EditarPerfilEvento, EditarPerfilEstado> {
  final EditarUsuarioCasoDeUso editarUsuarioCasoDeUso;

  EditarPerfilBloc({required this.editarUsuarioCasoDeUso})
    : super(EditarPerfilInicial()) {
    on<EditarPerfilRequisicaoEvento>(_aoEditarPerfil);
  }

  Future<void> _aoEditarPerfil(
    EditarPerfilRequisicaoEvento evento,
    Emitter<EditarPerfilEstado> emit,
  ) async {
    emit(EditarPerfilCarregando());

    var resultado = await editarUsuarioCasoDeUso.chamar(
      novoNome: evento.novoNome,
      novoEmail: evento.novoEmail,
      novaImageURL: evento.novaImageURL,
      novaSenha: evento.novaSenha,
      senhaAtual: evento.senhaAtual,
    );

    resultado.fold(
      (falha) {
        emit(EditarPerfilFalha(falha.toString()));
      },
      (sucesso) {
        emit(EditarPerfilSucesso());
      },
    );
  }
}
