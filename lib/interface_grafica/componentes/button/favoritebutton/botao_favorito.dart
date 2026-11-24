import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/nucleo/configs/theme/cores_app.dart';
import 'package:project_sound_wave/camada_dados/dominio/entities/song/musica.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/favoritos_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/favoritos_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/favoritos_estado.dart';

/// Um botão de favorito que permite ao usuário adicionar ou remover uma música dos favoritos.
///
/// Este widget é um `StatefulWidget` porque seu estado visual (se a música é favorita ou não)
/// pode mudar ao longo do tempo, dependendo da interação do usuário e do estado do `FavoritosBloc`.
/// Ele interage diretamente com o `FavoritosBloc` para gerenciar o estado de favorito de uma música,
/// garantindo que a interface do usuário reflita o estado atual dos dados.
class BotaoFavorito extends StatefulWidget {
  /// A entidade da música associada a este botão de favorito.
  ///
  /// Contém todas as informações necessárias sobre a música para identificar
  /// e manipular seu status de favorito.
  final MusicaEntidade entidadeMusica;

  /// Uma função de callback opcional a ser chamada quando o estado de favorito muda.
  ///
  /// Permite que widgets pais reajam a mudanças no status de favorito da música,
  /// por exemplo, atualizando uma lista de músicas favoritas.
  final VoidCallback? aoMudarFavorito;

  /// Construtor para `BotaoFavorito`.
  ///
  /// Requer a `entidadeMusica` para identificar a música e aceita um `aoMudarFavorito` opcional.
  const BotaoFavorito({
    required this.entidadeMusica,
    this.aoMudarFavorito,
    super.key,
  });

  @override
  State<BotaoFavorito> createState() => _BotaoFavoritoState();
}

/// Estado do `BotaoFavorito`.
///
/// Gerencia a lógica de construção da interface do usuário e a interação com o `FavoritosBloc`.
class _BotaoFavoritoState extends State<BotaoFavorito> {
  @override
  Widget build(BuildContext context) {
    // `BlocBuilder` é usado para reconstruir a interface do usuário sempre que o estado
    /// do `FavoritosBloc` muda. Isso garante que o ícone e a cor do botão
    /// estejam sempre sincronizados com o estado de favorito da música.
    return BlocBuilder<FavoritosBloc, FavoritosEstado>(
      builder: (context, state) {
        // Exibe um indicador de carregamento enquanto o estado dos favoritos está sendo carregado.
        /// Isso proporciona feedback visual ao usuário durante operações assíncronas.
        if (state is FavoritosCarregando) {
          return const SizedBox(
            width: 40,
            height: 40,
            child: Center(child: CircularProgressIndicator(strokeWidth: 4)),
          );
        }

        // Determina se a música atual é favorita com base no estado do bloco.
        /// A lógica verifica se o `idMusica` da música atual está presente na lista
        /// de músicas favoritas carregadas pelo `FavoritosBloc`.
        bool eFavorito = false;
        if (state is FavoritosCarregados) {
          eFavorito = state.musicas.any(
            (musica) => musica.idMusica == widget.entidadeMusica.idMusica,
          );
        }

        // Retorna um `IconButton` que permite ao usuário alternar o estado de favorito da música.
        /// O ícone e a cor são dinamicamente definidos com base no estado `eFavorito`.
        return IconButton(
          onPressed: () {
            // Dispara o evento `AlternarFavorito` no `FavoritosBloc`.
            /// Isso notifica o bloco para adicionar ou remover a música da lista de favoritos.
            context.read<FavoritosBloc>().add(
              AlternarFavorito(widget.entidadeMusica.idMusica),
            );
            // Chama o callback opcional `aoMudarFavorito` se fornecido.
            /// Isso permite que outros widgets reajam a essa mudança.
            if (widget.aoMudarFavorito != null) {
              widget.aoMudarFavorito!();
            }
          },
          icon: Icon(
            // Altera o ícone com base no estado de favorito: coração preenchido para favorito,
            /// e contorno de coração para não favorito.
            eFavorito ? Icons.favorite : Icons.favorite_outline,
            size: 25,
            // Altera a cor do ícone: vermelho para favorito, cinza escuro para não favorito.
            color: eFavorito ? Colors.red : CoresApp.cinzaEscuro,
          ),
        );
      },
    );
  }
}
