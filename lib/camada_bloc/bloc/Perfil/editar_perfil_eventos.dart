abstract class EditarPerfilEvento {
  const EditarPerfilEvento();

  List<Object> get props => [];
}

class EditarPerfilRequisicaoEvento extends EditarPerfilEvento {
  final String? novoNome;
  final String? novoEmail;
  final String? novaImageURL;
  final String? novaSenha;
  final String senhaAtual;

  const EditarPerfilRequisicaoEvento({
    this.novoNome,
    this.novoEmail,
    this.novaImageURL,
    this.novaSenha,
    required this.senhaAtual,
  });

  @override
  List<Object> get props => [senhaAtual];
}
