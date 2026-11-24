import 'package:project_sound_wave/camada_dados/dominio/entities/song/musica.dart';

abstract class ListaReproducaoEstado {}

class ListaReproducaoInicial extends ListaReproducaoEstado {}

class ListaReproducaoCarregando extends ListaReproducaoEstado {}

class ListaReproducaoCarregada extends ListaReproducaoEstado {
  final List<MusicaEntidade> musicas;
  ListaReproducaoCarregada(this.musicas);
}

class ListaReproducaoErro extends ListaReproducaoEstado {
  final String mensagem;
  ListaReproducaoErro(this.mensagem);
}

class FavoritoAlternado extends ListaReproducaoEstado {
  final bool eAgoraFavorito;
  FavoritoAlternado(this.eAgoraFavorito);
}
