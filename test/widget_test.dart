import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Configuracoes/tema_bloc.dart';
import 'package:project_sound_wave/camada_dados/dados/models/auth/usuario.dart';
import 'package:project_sound_wave/camada_dados/dados/models/song/musica.dart';
import 'package:project_sound_wave/nucleo/configs/theme/tema_app.dart';

void main() {
  group('TemaBloc', () {
    test('inicia com o tema escuro por padrão', () {
      final bloc = TemaBloc();
      expect(bloc.state.dadosDoTema, equals(TemaApp.temaEscuro));
      expect(bloc.state.dadosDoTema.brightness, equals(Brightness.dark));
      bloc.close();
    });

    test('alterna entre tema claro e tema escuro ao receber TemaAlterado', () async {
      final bloc = TemaBloc();

      bloc.add(TemaAlterado(eEscuro: false));
      await expectLater(
        bloc.stream,
        emits(
          isA<TemaEstado>().having(
            (s) => s.dadosDoTema.brightness,
            'brightness',
            Brightness.light,
          ),
        ),
      );

      bloc.add(TemaAlterado(eEscuro: true));
      await expectLater(
        bloc.stream,
        emits(
          isA<TemaEstado>().having(
            (s) => s.dadosDoTema.brightness,
            'brightness',
            Brightness.dark,
          ),
        ),
      );

      await bloc.close();
    });
  });

  group('Modelos de Dados', () {
    test('MusicaModelo converte JSON para MusicaEntidade corretamente', () {
      final timestamp = Timestamp.fromDate(DateTime(2025, 1, 15));
      final modelo = MusicaModelo.fromJson({
        'title': 'SoundWave Theme',
        'artist': 'Artista Teste',
        'duration': 3.45,
        'releaseDate': timestamp,
        'coverURL': 'https://example.com/cover.png',
        'songURL': 'https://example.com/song.mp3',
      })
        ..idMusica = 'song-123'
        ..favorita = true;

      final entidade = modelo.converterModeloParaEntidade();

      expect(entidade.titulo, 'SoundWave Theme');
      expect(entidade.artista, 'Artista Teste');
      expect(entidade.duracao, 3.45);
      expect(entidade.dataDeLancamento, timestamp);
      expect(entidade.idMusica, 'song-123');
      expect(entidade.favorita, isTrue);
      expect(entidade.urlCapa, 'https://example.com/cover.png');
      expect(entidade.urlMusica, 'https://example.com/song.mp3');
    });

    test('UsuarioModelo converte JSON para UsuarioEntidade com fallbacks seguros', () {
      final modelo = UsuarioModelo.fromJson({
        'name': 'Rodrigo',
        'email': 'rodrigo@example.com',
        'imageURL': 'https://example.com/avatar.png',
      });

      final entidade = modelo.converterModeloParaEntidade();

      expect(entidade.nomeCompleto, 'Rodrigo');
      expect(entidade.email, 'rodrigo@example.com');
      expect(entidade.urlImagem, 'https://example.com/avatar.png');

      final modeloVazio = UsuarioModelo.fromJson({});
      final entidadeVazia = modeloVazio.converterModeloParaEntidade();

      expect(entidadeVazia.nomeCompleto, '');
      expect(entidadeVazia.email, '');
      expect(entidadeVazia.urlImagem, isNull);
    });
  });
}
