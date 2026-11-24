import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/sair_usuario.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/sair_usuario_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/sair_usuario_estado.dart';

class SairUsuarioBloc extends Bloc<SairUsuarioEvento, SairUsuarioEstado> {
  final SairUsuarioCasoDeUso sairUsuarioCasoDeUso;

  SairUsuarioBloc({required this.sairUsuarioCasoDeUso})
    : super(SairUsuarioCarregando()) {
    on<SairUsuarioRequisicaoEvento>(_aoRequisitarSairUsuario);
  }

  Future<void> _aoRequisitarSairUsuario(
    SairUsuarioRequisicaoEvento evento,
    Emitter<SairUsuarioEstado> emit,
  ) async {
    emit(SairUsuarioCarregando());

    var resultado = await sairUsuarioCasoDeUso.chamar();

    resultado.fold(
      (falha) => emit(SairUsuarioFalha(mensagem: falha.toString())),
      (sucesso) => emit(SairUsuarioSucesso()),
    );
  }
}
