import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/reprodutor_musica_events.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/reprodutor_musica_state.dart';
import 'package:project_sound_wave/nucleo/configs/theme/cores_app.dart';
import 'package:project_sound_wave/interface_grafica/componentes/appbar/barra_app.dart';
import 'package:project_sound_wave/interface_grafica/componentes/button/favoritebutton/botao_favorito.dart';
import 'package:project_sound_wave/camada_dados/dominio/entities/song/musica.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/reprodutor_musica_bloc.dart';

class PaginaReprodutorMusica extends StatefulWidget {
  final MusicaEntidade musica;
  final List<MusicaEntidade> playlist;
  final int indiceInicial;

  const PaginaReprodutorMusica({
    required this.musica,
    required this.playlist,
    required this.indiceInicial,
    super.key,
  });

  @override
  State<PaginaReprodutorMusica> createState() => _PaginaReprodutorMusicaState();
}

class _PaginaReprodutorMusicaState extends State<PaginaReprodutorMusica> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<BlocReprodutorMusica>();

    // Define a playlist no BLoC assim que a página é inicializada.
    bloc.add(EventoDefinirPlaylist(widget.playlist));

    // Carrega a música inicial e a reproduz automaticamente.
    bloc.add(EventoCarregarMusica(widget.musica, tocarAutomaticamente: true));

    // Atualiza o índice da música atual na playlist do BLoC.
    final novoIndice = widget.playlist.indexWhere(
      (m) => m.idMusica == widget.musica.idMusica,
    );
    if (novoIndice != -1) {
      bloc.add(EventoAtualizarIndice(novoIndice));
    }
  }

  @override
  void didUpdateWidget(covariant PaginaReprodutorMusica oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Verifica se a música atual mudou e, se sim, carrega a nova música.
    if (oldWidget.musica.idMusica != widget.musica.idMusica) {
      final bloc = context.read<BlocReprodutorMusica>();
      bloc.add(EventoCarregarMusica(widget.musica));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraAppBasica(
        titulo: const Text('Tocando agora', style: TextStyle(fontSize: 18)),
        acao: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(children: [_construirReprodutorMusica(context)]),
      ),
    );
  }

  /// Constrói a seção da capa da música, exibindo a imagem da capa.
  Widget _construirCapaMusica(BuildContext context, MusicaEntidade musica) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(musica.urlCapa), // Usa a URL da capa da música.
        ),
      ),
    );
  }

  /// Constrói a seção de detalhes da música, incluindo título, artista e botão de favorito.
  Widget _construirDetalhesMusica(MusicaEntidade musica) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                musica.titulo, // Exibe o título da música.
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                musica.artista, // Exibe o nome do artista.
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        BotaoFavorito(
          entidadeMusica: musica,
        ), // Botão para favoritar/desfavoritar a música.
      ],
    );
  }

  /// Constrói o reprodutor de música completo, incluindo capa, detalhes, slider de progresso e controles de reprodução.
  Widget _construirReprodutorMusica(BuildContext context) {
    return BlocConsumer<BlocReprodutorMusica, EstadoReprodutor>(
      listener: (context, state) {},
      builder: (context, state) {
        final bloc = context.read<BlocReprodutorMusica>();
        // Usa a música atual do BLoC, com fallback para a música inicial se não houver uma definida.
        final musicaAtual = bloc.musicaAtual ?? widget.musica;

        // Exibe um indicador de carregamento enquanto a música está sendo carregada.
        if (state.estaCarregando) {
          return const Center(child: CircularProgressIndicator());
        }

        // Exibe uma mensagem de erro se ocorrer um problema.
        if (state.erro != null) {
          return Center(child: Text(state.erro!));
        }

        return Column(
          children: [
            _construirCapaMusica(context, musicaAtual), // Capa da música.
            const SizedBox(height: 20),
            _construirDetalhesMusica(musicaAtual), // Detalhes da música.
            const SizedBox(height: 30),
            // Slider para controlar o progresso da reprodução.
            Slider(
              value: state.posicao.inSeconds.toDouble().clamp(
                0.0,
                state.duracao.inSeconds > 0
                    ? state.duracao.inSeconds.toDouble()
                    : 1.0,
              ),
              min: 0.0,
              max:
                  state.duracao.inSeconds > 0
                      ? state.duracao.inSeconds.toDouble()
                      : 1.0,
              onChanged: (value) {
                // Permite ao usuário arrastar o slider para buscar uma posição na música.
                bloc.audioPlayer.seek(Duration(seconds: value.toInt()));
              },
            ),
            const SizedBox(height: 20),
            // Exibe o tempo atual e a duração total da música.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatarDuracao(state.posicao)),
                Text(_formatarDuracao(state.duracao)),
              ],
            ),
            const SizedBox(height: 20),
            // Controles de reprodução: música anterior, tocar/pausar, próxima música.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    context.read<BlocReprodutorMusica>().add(
                      EventoMusicaAnterior(),
                    );
                  },
                  icon: const Icon(Icons.skip_previous_rounded),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    bloc.add(EventoTocarOuPausarMusica());
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: CoresApp.primaria,
                    ),
                    child: Icon(
                      state.estaTocando ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    context.read<BlocReprodutorMusica>().add(
                      EventoProximaMusica(),
                    );
                  },
                  icon: const Icon(Icons.skip_next_rounded),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Formata a duração de um objeto [Duration] para uma string no formato "MM:SS".
  String _formatarDuracao(Duration duracao) {
    final minutos = duracao.inMinutes.remainder(60);
    final segundos = duracao.inSeconds.remainder(60);
    return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
  }
}
