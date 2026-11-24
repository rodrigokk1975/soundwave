import 'package:project_sound_wave/camada_dados/dominio/entities/song/musica.dart';

abstract class FavoritosEstado {}

class FavoritosInicial extends FavoritosEstado {}

class FavoritosCarregando extends FavoritosEstado {}

class FavoritosCarregados extends FavoritosEstado {
  final List<MusicaEntidade> musicas;
  FavoritosCarregados(this.musicas);
}

class FavoritosErro extends FavoritosEstado {
  final String mensagem;
  FavoritosErro(this.mensagem);
}
