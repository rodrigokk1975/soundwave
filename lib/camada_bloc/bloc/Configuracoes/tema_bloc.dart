import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/nucleo/configs/theme/tema_app.dart';

part 'tema_evento.dart';
part 'tema_estado.dart';

class TemaBloc extends Bloc<TemaEvento, TemaEstado> {
  TemaBloc() : super(TemaEstado(dadosDoTema: TemaApp.temaEscuro)) {
    on<TemaAlterado>((evento, emit) {
      emit(
        TemaEstado(
          dadosDoTema: evento.eEscuro ? TemaApp.temaEscuro : TemaApp.temaClaro,
        ),
      );
    });
  }
}
