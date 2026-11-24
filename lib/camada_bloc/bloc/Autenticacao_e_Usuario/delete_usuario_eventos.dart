abstract class DeleteUsuarioEvento {
  const DeleteUsuarioEvento();
}

class DeleteUsuarioRequisicaoEvento extends DeleteUsuarioEvento {
  final String senhaDigitada;

  DeleteUsuarioRequisicaoEvento({required this.senhaDigitada});
}
