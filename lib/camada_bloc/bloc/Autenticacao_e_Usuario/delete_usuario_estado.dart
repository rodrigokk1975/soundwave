abstract class DeleteUsuarioEstado {}

class DeleteUsuarioInicial extends DeleteUsuarioEstado {}

class DeleteUsuarioCarregando extends DeleteUsuarioEstado {}

class DeleteUsuarioSucesso extends DeleteUsuarioEstado {}

class DeleteUsuarioFalha extends DeleteUsuarioEstado {
  final String mensagem;
  DeleteUsuarioFalha({required this.mensagem});
}
