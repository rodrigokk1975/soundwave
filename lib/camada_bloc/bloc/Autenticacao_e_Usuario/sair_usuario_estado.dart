abstract class SairUsuarioEstado {}

class SairUsuarioCarregando extends SairUsuarioEstado {}

class SairUsuarioSucesso extends SairUsuarioEstado {}

class SairUsuarioFalha extends SairUsuarioEstado {
  final String mensagem;

  SairUsuarioFalha({required this.mensagem});
}
