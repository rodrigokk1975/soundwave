abstract class EditarPerfilEstado {}

class EditarPerfilInicial extends EditarPerfilEstado {}

class EditarPerfilCarregando extends EditarPerfilEstado {}

class EditarPerfilSucesso extends EditarPerfilEstado {}

class EditarPerfilFalha extends EditarPerfilEstado {
  final String mensagem;
  EditarPerfilFalha(this.mensagem);
}
