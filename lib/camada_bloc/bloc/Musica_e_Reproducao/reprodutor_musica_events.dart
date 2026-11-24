import 'package:project_sound_wave/camada_dados/dominio/entities/song/musica.dart';

abstract class EventoReprodutor {}

class EventoCarregarMusica extends EventoReprodutor {
  final MusicaEntidade musica;
  final bool tocarAutomaticamente;
  EventoCarregarMusica(this.musica, {this.tocarAutomaticamente = true});
}

class EventoTocarOuPausarMusica extends EventoReprodutor {}

class EventoAtualizarReprodutor extends EventoReprodutor {
  final Duration? posicao;
  final Duration? duracao;

  EventoAtualizarReprodutor({this.posicao, this.duracao});
}

class EventoResetarReprodutor extends EventoReprodutor {}

class EventoProximaMusica extends EventoReprodutor {}

class EventoMusicaAnterior extends EventoReprodutor {}

class EventoDefinirPlaylist extends EventoReprodutor {
  final List<MusicaEntidade> playlist;
  EventoDefinirPlaylist(this.playlist);
}

class EventoAtualizarIndice extends EventoReprodutor {
  final int novoIndice;
  EventoAtualizarIndice(this.novoIndice);
}
