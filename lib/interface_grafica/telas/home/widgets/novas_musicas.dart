import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/lista_reproducao_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/lista_reproducao_estado.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/novas_musicas_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/novas_musicas_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/novas_musicas_estado.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/reprodutor_musica_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/reprodutor_musica_events.dart';
import 'package:project_sound_wave/interface_grafica/telas/song_player/pages/reprodutor_musica.dart';

/// Este widget é responsável por exibir uma lista horizontal de novas músicas.
class NovasMusicas extends StatelessWidget {
  const NovasMusicas({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NovasMusicasBloc, NovasMusicasEstado>(
      builder: (context, state) {
        // Exibe um indicador de progresso enquanto as músicas estão sendo carregadas.
        if (state is NovasMusicasCarregando) {
          return const Center(child: CircularProgressIndicator());
        }
        // Exibe uma mensagem de erro detalhada e um botão para tentar recarregar as músicas.
        else if (state is NovasMusicasErro) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 16),
              Text(
                'Erro ao carregar músicas:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                state.mensagem,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    () => context.read<NovasMusicasBloc>().add(
                      CarregarNovasMusicas(),
                    ), // Dispara o evento para tentar carregar novamente.
                child: const Text('Tentar novamente'),
              ),
            ],
          );
        }
        // Quando as músicas são carregadas com sucesso, exibe a lista horizontal.
        else if (state is NovasMusicasCarregadas) {
          final musicas = state.musicas;

          return SizedBox(
            height: 200,
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 28),
              scrollDirection: Axis.horizontal, // Define a rolagem horizontal.
              itemCount: musicas.length, // Número de itens na lista.
              separatorBuilder:
                  (_, __) =>
                      const SizedBox(width: 14), // Espaçamento entre os itens.
              itemBuilder: (context, index) {
                final musica = musicas[index];
                return GestureDetector(
                  onTap: () {
                    final reprodutorBloc = context.read<BlocReprodutorMusica>();
                    // Verifica se a música selecionada já está sendo reproduzida.
                    final mesmaMusica =
                        reprodutorBloc.musicaAtual?.idMusica == musica.idMusica;

                    if (!mesmaMusica) {
                      // Se for uma música diferente, reseta o reprodutor e inicia a reprodução automaticamente.
                      reprodutorBloc.add(EventoResetarReprodutor());
                      reprodutorBloc.add(
                        EventoCarregarMusica(
                          musica,
                          tocarAutomaticamente: true,
                        ),
                      );
                    } else {
                      // Se for a mesma música, apenas alterna entre play/pause sem reiniciar a reprodução.
                      reprodutorBloc.add(
                        EventoCarregarMusica(
                          musica,
                          tocarAutomaticamente:
                              false, // Impede que a música reinicie.
                        ),
                      );
                    }

                    // Navega para a tela do reprodutor de música.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          // Tenta obter a playlist do `ListaReproducaoBloc` para passar ao reprodutor.
                          final listaReproducaoState =
                              context.read<ListaReproducaoBloc>().state;
                          if (listaReproducaoState
                              is ListaReproducaoCarregada) {
                            final indice = listaReproducaoState.musicas
                                .indexWhere(
                                  (m) => m.idMusica == musica.idMusica,
                                );
                            return PaginaReprodutorMusica(
                              musica: musica,
                              playlist: listaReproducaoState.musicas,
                              indiceInicial: indice != -1 ? indice : 0,
                            );
                          } else {
                            // Usa a lista de músicas carregadas pelo `NovasMusicasBloc`.
                            return PaginaReprodutorMusica(
                              musica: musica,
                              playlist: state.musicas,
                              indiceInicial: state.musicas.indexOf(musica),
                            );
                          }
                        },
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  musica.urlCapa,
                                ), // Exibe a capa da música.
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 40,
                                width: 40,
                                transform: Matrix4.translationValues(
                                  10,
                                  10,
                                  0,
                                ), // Posiciona o botão de play.
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  // Cor do botão de play com opacidade.
                                  color: Colors.white.withValues(
                                    alpha: 0.7 * 255,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                ), // Ícone de play.
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          musica.titulo, // Título da música.
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          musica.artista, // Nome do artista.
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        // Retorna um widget vazio para estados não tratados ou iniciais.
        else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
