import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/sair_usuario_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/sair_usuario_estado.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/sair_usuario_eventos.dart';
import 'package:project_sound_wave/interface_grafica/componentes/bottomappbar/bottom_app.dart';
import 'package:project_sound_wave/interface_grafica/telas/auth/pages/cadastro_ou_entrar.dart';
import 'package:project_sound_wave/interface_grafica/telas/configurations/pages/configuracoes.dart';
import 'package:project_sound_wave/nucleo/configs/assets/imagens_app.dart';
import 'package:project_sound_wave/nucleo/configs/assets/vetores_app.dart';
import 'package:project_sound_wave/nucleo/configs/theme/cores_app.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/favoritos_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/favoritos_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/novas_musicas_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/novas_musicas_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/lista_reproducao_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/lista_reproducao_eventos.dart';
import 'package:project_sound_wave/interface_grafica/telas/profile/pages/perfil.dart';
import 'package:project_sound_wave/interface_grafica/componentes/appbar/barra_app.dart';
import 'package:project_sound_wave/interface_grafica/telas/home/widgets/novas_musicas.dart';
import 'package:project_sound_wave/interface_grafica/telas/home/widgets/lista_de_reproducao.dart';

/// Navegação entre diferentes telas (Home, Perfil, Configurações) através de uma barra de navegação inferior.
class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  int _indiceAtual = 0; // Controla qual tela está sendo exibida atualmente.

  // Lista das telas que podem ser exibidas na `PaginaInicial`.
  final List<Widget> _telas = [
    const ConteudoPaginaInicial(),
    const PaginaPerfil(),
    const PaginaConfiguracoes(),
  ];

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, dispara eventos para carregar as músicas favoritas,
    // as playlists e as novas músicas.
    context.read<FavoritosBloc>().add(CarregarFavoritos());
    context.read<ListaReproducaoBloc>().add(CarregarListaReproducao());
    context.read<NovasMusicasBloc>().add(CarregarNovasMusicas());
  }

  @override
  Widget build(BuildContext context) {
    // Ouve as mudanças de estado do `SairUsuarioBloc` para lidar com o processo de logout.
    // Em caso de sucesso, navega para a tela de login/cadastro; em caso de falha, exibe uma mensagem.
    return BlocListener<SairUsuarioBloc, SairUsuarioEstado>(
      listener: (context, state) {
        if (state is SairUsuarioSucesso) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PaginaCadastroOuEntrar(),
            ),
          );
        } else if (state is SairUsuarioFalha) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.mensagem)));
        }
      },
      child: Scaffold(
        // A AppBar é exibida apenas quando o índice atual é 0 (tela inicial).
        // Contém um botão de logout e o logotipo do aplicativo.
        appBar:
            _indiceAtual == 0
                ? BarraAppBasica(
                  principal: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed:
                        () => _confirmarLogout(
                          context,
                        ), // Chama o método de confirmação de logout.
                  ),
                  titulo: SvgPicture.asset(
                    VetoresApp.logo,
                    height: 40,
                    width: 40,
                  ),
                )
                : null, // Não exibe AppBar em outras telas.
        body:
            _telas[_indiceAtual], // Exibe a tela correspondente ao índice atual.
        bottomNavigationBar: BottomNavigationBarPersonalizado(
          indiceAtual: _indiceAtual,
          onTap: (indice) {
            setState(() {
              _indiceAtual = indice; // Atualiza o índice da tela selecionada.
            });
          },
        ),
      ),
    );
  }

  /// Exibe um diálogo de confirmação para o usuário antes de efetuar o logout.
  void _confirmarLogout(BuildContext context) {
    final sairBloc = context.read<SairUsuarioBloc>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Sair da conta',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ), // Estilo para o título do diálogo.
            ),
            content: const Text('Tem certeza que deseja sair da sua conta?'),
            actions: [
              TextButton(
                onPressed:
                    () => Navigator.pop(context), // Fecha o diálogo sem sair.
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o diálogo.
                  sairBloc.add(
                    SairUsuarioRequisicaoEvento(),
                  ); // Dispara o evento de logout.
                },
                child: const Text(
                  'Sair',
                  style: TextStyle(
                    color: Colors.red,
                  ), // Destaca o botão de sair.
                ),
              ),
            ],
          ),
    );
  }
}

/// Conteúdo principal da tela inicial do aplicativo.
class ConteudoPaginaInicial extends StatelessWidget {
  const ConteudoPaginaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _cartaoSuperiorInicio(),
            // Permitem ao usuário alternar entre diferentes categorias de conteúdo.
            _abas(),
            // Exibe o conteúdo correspondente à aba selecionada.
            SizedBox(
              height: 260, // Altura fixa para o conteúdo das abas.
              child: TabBarView(
                children: [
                  const NovasMusicas(),
                  _abaVazia("Vídeos"),
                  _abaVazia("Artistas"),
                  _abaVazia("Podcasts"),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Exibe uma lista de músicas, que pode ser uma playlist geral.
            ListaDeReproducao(
              titulo: 'Playlist',
              apenasMusicasFavoritas: false,
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o widget do cartão superior da página inicial.
  Widget _cartaoSuperiorInicio() {
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          // Um elemento gráfico SVG que serve como plano de fundo para o cartão.
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(VetoresApp.cartaoSuperiorInicio),
          ),
          // Uma imagem decorativa, posicionada no cartão.
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 170,
              ), // Ajusta a posição da imagem.
              child: Image.asset(ImagensApp.artistaInicio),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o widget `TabBar` para as abas de navegação.
  Widget _abas() {
    return TabBar(
      dividerColor:
          Colors.transparent, // Remove a linha divisória entre as abas.
      isScrollable:
          false, // Garante que as abas não sejam roladas horizontalmente.
      indicatorColor:
          CoresApp.primaria, // Define a cor do indicador da aba selecionada.
      padding: const EdgeInsets.only(
        top: 40,
        right: 24,
        left: 24,
        bottom: 20,
      ), // Espaçamento das abas.
      tabs: const [
        Text(
          'Novos',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          'Vídeos',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          'Artistas',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          'Podcasts',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ],
    );
  }

  /// Constrói um widget simples para representar o conteúdo de uma aba vazia.
  Widget _abaVazia(String rotulo) {
    return Center(
      child: Text(
        'Nenhum $rotulo disponível',
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
