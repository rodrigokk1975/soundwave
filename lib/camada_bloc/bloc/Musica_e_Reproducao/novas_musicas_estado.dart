import 'package:project_sound_wave/camada_dados/dominio/entities/song/musica.dart';

abstract class NovasMusicasEstado {}

class NovasMusicasInicial extends NovasMusicasEstado {}

class NovasMusicasCarregando extends NovasMusicasEstado {}

class NovasMusicasCarregadas extends NovasMusicasEstado {
  final List<MusicaEntidade> musicas;
  NovasMusicasCarregadas(this.musicas);
}

class NovasMusicasErro extends NovasMusicasEstado {
  final String mensagem;
  NovasMusicasErro(this.mensagem);
}
