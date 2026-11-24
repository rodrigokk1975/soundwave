import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/deletar_usuario.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/delete_usuario_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/delete_usuario_estado.dart';

class DeleteUsuarioBloc extends Bloc<DeleteUsuarioEvento, DeleteUsuarioEstado> {
  final DeletarUsuarioCasoDeUso deletarUsuarioCasoDeUso;

  DeleteUsuarioBloc({required this.deletarUsuarioCasoDeUso})
    : super(DeleteUsuarioInicial()) {
    on<DeleteUsuarioRequisicaoEvento>(_aoRequisitarDeleteUsuario);
  }

  Future<void> _aoRequisitarDeleteUsuario(
    DeleteUsuarioRequisicaoEvento evento,
    Emitter<DeleteUsuarioEstado> emit,
  ) async {
    emit(DeleteUsuarioCarregando());

    final resultado = await deletarUsuarioCasoDeUso.chamar(
      evento.senhaDigitada,
    );

    resultado.fold(
      (falha) => emit(DeleteUsuarioFalha(mensagem: falha.toString())),
      (sucesso) => emit(DeleteUsuarioSucesso()),
    );
  }
}
