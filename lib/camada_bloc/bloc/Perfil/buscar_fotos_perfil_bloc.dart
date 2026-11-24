import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/buscar_fotos_perfil.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/buscar_fotos_perfil_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/buscar_fotos_perfil_estado.dart';

class BuscarFotosPerfilBloc
    extends Bloc<BuscarFotosPerfilEvento, BuscarFotosPerfilEstado> {
  final BuscarFotosPerfilCasoDeUso buscarFotosPerfilCasoDeUso;

  BuscarFotosPerfilBloc({required this.buscarFotosPerfilCasoDeUso})
    : super(BuscarFotosPerfilCarregando()) {
    on<BuscarFotosPerfilRequisicaoEvento>(_aoRequisitarFotosPerfil);
  }

  Future<void> _aoRequisitarFotosPerfil(
    BuscarFotosPerfilRequisicaoEvento evento,
    Emitter<BuscarFotosPerfilEstado> emit,
  ) async {
    emit(BuscarFotosPerfilCarregando());

    try {
      final resultado = await buscarFotosPerfilCasoDeUso.chamar();

      resultado.fold(
        (falha) => emit(BuscarFotosPerfilFalha()),
        (fotos) => emit(BuscarFotosPerfilCarregado(fotos: fotos)),
      );
    } catch (e) {
      emit(BuscarFotosPerfilFalha());
    }
  }
}
