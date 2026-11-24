/// Classe que contém os caminhos para os vetores SVG utilizados no aplicativo.
class VetoresApp {
  /// Caminho base para todos os vetores.
  static const String caminhoBase = 'assets/vectors/';
  /// Formato dos arquivos de vetor.
  static const String formato = '.svg';

  /// Vetor do logotipo.
  static const String logo = '${caminhoBase}soundwave_logo$formato';
  /// Vetor do sol (para tema claro).
  static const String sol = '${caminhoBase}sun$formato';
  /// Vetor da lua (para tema escuro).
  static const String lua = '${caminhoBase}moon$formato';
  /// Vetor do padrão superior.
  static const String padraoSuperior = '${caminhoBase}top_pattern$formato';
  /// Vetor do padrão inferior.
  static const String padraoInferior = '${caminhoBase}bottom_pattern$formato';
  /// Vetor do cartão superior da tela inicial.
  static const String cartaoSuperiorInicio = '${caminhoBase}home_top_card$formato';
}


