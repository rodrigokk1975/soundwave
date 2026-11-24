class EstadoReprodutor {
  final Duration posicao;
  final Duration duracao;
  final bool estaTocando;
  final bool estaCarregando;
  final String? erro;
  final int indiceAtual;

  const EstadoReprodutor({
    this.posicao = Duration.zero,
    this.duracao = Duration.zero,
    this.estaTocando = false,
    this.estaCarregando = false,
    this.erro,
    this.indiceAtual = 0,
  });

  EstadoReprodutor copyWith({
    Duration? posicao,
    Duration? duracao,
    bool? estaTocando,
    bool? estaCarregando,
    String? erro,
    int? indiceAtual,
  }) {
    return EstadoReprodutor(
      posicao: posicao ?? this.posicao,
      duracao: duracao ?? this.duracao,
      estaTocando: estaTocando ?? this.estaTocando,
      estaCarregando: estaCarregando ?? this.estaCarregando,
      erro: erro ?? this.erro,
      indiceAtual: indiceAtual ?? this.indiceAtual,
    );
  }
}
