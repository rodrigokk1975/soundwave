import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/reprodutor_musica_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/reprodutor_musica_events.dart';
import 'package:project_sound_wave/nucleo/configs/theme/cores_app.dart';
import 'package:project_sound_wave/camada_dados/dominio/entities/song/musica.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/favoritos_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/favoritos_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/favoritos_estado.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/lista_reproducao_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/lista_reproducao_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/lista_reproducao_estado.dart';
import 'package:project_sound_wave/interface_grafica/telas/song_player/pages/reprodutor_musica.dart';
import 'package:project_sound_wave/interface_grafica/componentes/button/favoritebutton/botao_favorito.dart';

class ListaDeReproducao extends StatelessWidget {
  final String titulo;
  final bool apenasMusicasFavoritas;

  /// Adiciona um preenchimento (padding) ao redor da lista de reprodução.
  final EdgeInsetsGeometry? padding;

  const ListaDeReproducao({
    required this.titulo,
    required this.apenasMusicasFavoritas,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // O widget decide qual BLoC (Favoritos ou ListaReproducao) deve ser utilizado.
    if (apenasMusicasFavoritas) {
      return BlocBuilder<FavoritosBloc, FavoritosEstado>(
        builder: (context, state) {
          return _construirConteudoFavoritos(context, state);
        },
      );
    } else {
      return BlocBuilder<ListaReproducaoBloc, ListaReproducaoEstado>(
        builder: (context, state) {
          return _construirConteudoPlaylist(context, state);
        },
      );
    }
  }

  /// Constrói a interface para exibir a lista de músicas favoritas.
  Widget _construirConteudoFavoritos(
    BuildContext context,
    FavoritosEstado state,
  ) {
    // Se o estado for `FavoritosInicial`, dispara o evento para carregar as músicas favoritas.
    if (state is FavoritosInicial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<FavoritosBloc>().add(CarregarFavoritos());
      });
    }

    return Padding(
      padding:
          padding ?? const EdgeInsets.only(bottom: 40, left: 30, right: 30),
      child: Column(
        children: [
          _construirTitulo(), // Exibe o título da lista.
          const SizedBox(height: 20),
          // Baseado no estado do BLoC, exibe um indicador de carregamento,
          // a lista de músicas carregadas, ou uma mensagem de erro.
          if (state is FavoritosCarregando)
            const CircularProgressIndicator() // Indicador de carregamento.
          else if (state is FavoritosCarregados)
            _listaDeMusicas(state.musicas) // Lista de músicas favoritas.
          else if (state is FavoritosErro)
            Text(
              'Erro: ${state.mensagem}',
              style: const TextStyle(
                color: Colors.red,
              ), // Estilo para mensagem de erro.
            )
          else
            const CircularProgressIndicator(),
        ],
      ),
    );
  }

  /// Constrói a interface para exibir uma lista de reprodução geral.
  Widget _construirConteudoPlaylist(
    BuildContext context,
    ListaReproducaoEstado state,
  ) {
    // Se o estado for `ListaReproducaoInicial`, dispara o evento para carregar a playlist.
    if (state is ListaReproducaoInicial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ListaReproducaoBloc>().add(CarregarListaReproducao());
      });
    }

    return Padding(
      padding:
          padding ?? const EdgeInsets.only(bottom: 40, left: 30, right: 30),
      child: Column(
        children: [
          _construirTitulo(),
          const SizedBox(height: 20),
          // Baseado no estado do BLoC, exibe um indicador de carregamento,
          // a lista de músicas carregadas, ou uma mensagem de erro.
          if (state is ListaReproducaoCarregando)
            const CircularProgressIndicator() // Indicador de carregamento.
          else if (state is ListaReproducaoCarregada)
            _listaDeMusicas(state.musicas) // Lista de músicas da playlist.
          else if (state is ListaReproducaoErro)
            Text(
              'Erro: ${state.mensagem}',
              style: const TextStyle(
                color: Colors.red,
              ), // Estilo para mensagem de erro.
            )
          else
            const CircularProgressIndicator(),
        ],
      ),
    );
  }

  /// Constrói o widget que exibe o título da lista de reprodução.
  Widget _construirTitulo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }

  /// Constrói a lista de músicas utilizando `ListView.separated`.
  Widget _listaDeMusicas(List<MusicaEntidade> musicas) {
    // Se a lista de músicas estiver vazia, exibe uma mensagem informativa.
    if (musicas.isEmpty) {
      return const Text(
        'Nenhuma música encontrada',
        style: TextStyle(
          color: Colors.grey,
        ), // Estilo para mensagem de lista vazia.
      );
    }

    return ListView.separated(
      shrinkWrap:
          true, // Permite que o ListView ocupe apenas o espaço necessário.
      physics:
          const NeverScrollableScrollPhysics(), // Desabilita a rolagem interna do ListView.
      itemCount: musicas.length, // Número total de músicas na lista.
      separatorBuilder:
          (context, index) =>
              const SizedBox(height: 20), // Espaçamento entre os itens.
      itemBuilder: (context, index) {
        final musica = musicas[index];

        return GestureDetector(
          onTap: () {
            final reprodutorBloc = context.read<BlocReprodutorMusica>();
            // Verifica se a música tocada é a mesma que já está no reprodutor.
            final mesmaMusica =
                reprodutorBloc.musicaAtual?.idMusica == musica.idMusica;

            if (!mesmaMusica) {
              // Se for uma música diferente, reseta o reprodutor e carrega a nova música para tocar automaticamente.
              reprodutorBloc.add(EventoResetarReprodutor());
              reprodutorBloc.add(
                EventoCarregarMusica(musica, tocarAutomaticamente: true),
              );
            } else {
              // Se for a mesma música, apenas alterna entre play/pause sem reiniciar a reprodução.
              reprodutorBloc.add(
                EventoCarregarMusica(
                  musica,
                  tocarAutomaticamente:
                      false, // Importante para não reiniciar a música.
                ),
              );
            }

            // Navega para a tela do reprodutor de música, passando a música atual, a playlist e o índice inicial.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => PaginaReprodutorMusica(
                      musica: musica,
                      playlist: musicas,
                      indiceInicial: musicas.indexOf(musica),
                    ),
              ),
            );
          },
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 60,
            ), // Garante uma altura mínima para o item.
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              CoresApp.cinza, // Cor de fundo do ícone de play.
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Color(0xff555555), // Cor do ícone de play.
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              musica.titulo, // Título da música.
                              overflow:
                                  TextOverflow
                                      .ellipsis, // Trunca o texto se for muito longo.
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              musica.artista, // Nome do artista.
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatarDuracao(musica.duracao),
                    ), // Duração da música formatada.
                    const SizedBox(width: 20),
                    BotaoFavorito(
                      entidadeMusica: musica,
                    ), // Botão de favorito para a música.
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Formata a duração de uma música (em segundos) para uma string no formato "MM:SS".
  String _formatarDuracao(num duracao) {
    final minutos = duracao.floor(); // Obtém a parte inteira dos minutos.
    // Calcula os segundos, ajustando para garantir que fiquem entre 0 e 59.
    final segundos = ((duracao - minutos) * 100).round().clamp(0, 59);
    return '$minutos:${segundos.toString().padLeft(2, '0')}'; // Formata para MM:SS.
  }
}
