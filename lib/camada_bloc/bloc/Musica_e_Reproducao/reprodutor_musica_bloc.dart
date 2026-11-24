import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/reprodutor_musica_events.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/reprodutor_musica_state.dart';
import 'package:project_sound_wave/camada_dados/dominio/entities/song/musica.dart';

class BlocReprodutorMusica extends Bloc<EventoReprodutor, EstadoReprodutor> {
  final AudioPlayer audioPlayer = AudioPlayer();
  MusicaEntidade? _musicaAtual;
  List<MusicaEntidade> _playlist = [];
  List<MusicaEntidade> _playlistPrincipal = [];

  MusicaEntidade? get musicaAtual => _musicaAtual;
  List<MusicaEntidade> get playlist => _playlist;

  static final BlocReprodutorMusica _instance =
      BlocReprodutorMusica._internal();
  factory BlocReprodutorMusica() => _instance;

  BlocReprodutorMusica._internal() : super(EstadoReprodutor()) {
    on<EventoCarregarMusica>(_onCarregarMusica);
    on<EventoTocarOuPausarMusica>(_onTocarOuPausarMusica);
    on<EventoAtualizarReprodutor>(_onAtualizarReprodutor);
    on<EventoResetarReprodutor>(_onResetarReprodutor);
    on<EventoProximaMusica>(_onProximaMusica);
    on<EventoMusicaAnterior>(_onMusicaAnterior);
    on<EventoDefinirPlaylist>(_onDefinirPlaylist);
    on<EventoAtualizarIndice>(_onAtualizarIndice);

    audioPlayer.onPlayerStateChanged.listen((state) {
      add(EventoAtualizarReprodutor());
    });

    audioPlayer.onPositionChanged.listen((posicao) {
      add(EventoAtualizarReprodutor(posicao: posicao));
    });

    audioPlayer.onDurationChanged.listen((duracao) {
      add(EventoAtualizarReprodutor(duracao: duracao));
    });
  }

  Future<void> _onCarregarMusica(
    EventoCarregarMusica evento,
    Emitter<EstadoReprodutor> emit,
  ) async {
    try {
      emit(state.copyWith(estaCarregando: true));

      if (_musicaAtual?.idMusica == evento.musica.idMusica) {
        if (audioPlayer.state == PlayerState.paused) {
          await audioPlayer.resume();
          emit(state.copyWith(estaCarregando: false, estaTocando: true));
        } else if (audioPlayer.state == PlayerState.playing) {
          await audioPlayer.pause();
          emit(state.copyWith(estaCarregando: false, estaTocando: false));
        }
        return;
      }

      int novoIndice = _playlistPrincipal.indexWhere(
        (m) => m.idMusica == evento.musica.idMusica,
      );
      if (novoIndice == -1) novoIndice = 0;

      _musicaAtual = evento.musica;
      await audioPlayer.stop();
      await Future.delayed(const Duration(milliseconds: 100));
      await audioPlayer.setSourceUrl(evento.musica.urlMusica);

      if (evento.tocarAutomaticamente) {
        await audioPlayer.resume();
      }

      emit(
        state.copyWith(
          estaCarregando: false,
          estaTocando: evento.tocarAutomaticamente,
          indiceAtual: novoIndice,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          estaCarregando: false,
          erro: 'Erro ao carregar música: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onTocarOuPausarMusica(
    EventoTocarOuPausarMusica evento,
    Emitter<EstadoReprodutor> emit,
  ) async {
    if (audioPlayer.state == PlayerState.playing) {
      await audioPlayer.pause();
      emit(state.copyWith(estaTocando: false));
    } else {
      await audioPlayer.resume();
      emit(state.copyWith(estaTocando: true));
    }
  }

  void _onAtualizarReprodutor(
    EventoAtualizarReprodutor evento,
    Emitter<EstadoReprodutor> emit,
  ) {
    emit(
      state.copyWith(
        estaTocando: audioPlayer.state == PlayerState.playing,
        posicao: evento.posicao ?? state.posicao,
        duracao: evento.duracao ?? state.duracao,
      ),
    );
  }

  Future<void> _onResetarReprodutor(
    EventoResetarReprodutor evento,
    Emitter<EstadoReprodutor> emit,
  ) async {
    await audioPlayer.stop();
    emit(EstadoReprodutor());
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }

  void _onDefinirPlaylist(
    EventoDefinirPlaylist evento,
    Emitter<EstadoReprodutor> emit,
  ) {
    _playlistPrincipal = evento.playlist;
    _playlist = evento.playlist;
  }

  Future<void> _onProximaMusica(
    EventoProximaMusica evento,
    Emitter<EstadoReprodutor> emit,
  ) async {
    if (_playlistPrincipal.isEmpty) return;

    int novoIndice;
    if (state.indiceAtual < _playlistPrincipal.length - 1) {
      novoIndice = state.indiceAtual + 1;
    } else {
      novoIndice = 0;
    }

    final proximaMusica = _playlistPrincipal[novoIndice];
    await _carregarMusicaComIndice(proximaMusica, novoIndice, emit);
  }

  Future<void> _onMusicaAnterior(
    EventoMusicaAnterior evento,
    Emitter<EstadoReprodutor> emit,
  ) async {
    if (_playlistPrincipal.isEmpty) return;

    int novoIndice;
    if (state.indiceAtual > 0) {
      novoIndice = state.indiceAtual - 1;
    } else {
      novoIndice = _playlistPrincipal.length - 1;
    }

    final musicaAnterior = _playlistPrincipal[novoIndice];
    await _carregarMusicaComIndice(musicaAnterior, novoIndice, emit);
  }

  Future<void> _carregarMusicaComIndice(
    MusicaEntidade musica,
    int novoIndice,
    Emitter<EstadoReprodutor> emit,
  ) async {
    _musicaAtual = musica;
    emit(state.copyWith(estaCarregando: true));
    await audioPlayer.stop();
    await audioPlayer.setSourceUrl(musica.urlMusica);
    await audioPlayer.resume();
    emit(
      state.copyWith(
        estaCarregando: false,
        estaTocando: true,
        indiceAtual: novoIndice,
      ),
    );
  }

  void _onAtualizarIndice(
    EventoAtualizarIndice evento,
    Emitter<EstadoReprodutor> emit,
  ) {
    emit(state.copyWith(indiceAtual: evento.novoIndice));
  }
}
