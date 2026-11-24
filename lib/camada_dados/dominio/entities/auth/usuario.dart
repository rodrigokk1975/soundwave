class UsuarioEntidade {
  String nomeCompleto;
  String email;
  String? urlImagem;

  UsuarioEntidade({
    required this.nomeCompleto,
    required this.email,
    this.urlImagem,
  });
}
