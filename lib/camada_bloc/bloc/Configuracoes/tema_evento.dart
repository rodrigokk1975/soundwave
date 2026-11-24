part of 'tema_bloc.dart';

abstract class TemaEvento {}

class TemaAlterado extends TemaEvento {
  final bool eEscuro;

  TemaAlterado({required this.eEscuro});
}
