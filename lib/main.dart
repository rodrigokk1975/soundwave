import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/buscar_fotos_perfil_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/delete_usuario_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/editar_perfil_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/reprodutor_musica_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/sair_usuario_bloc.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/buscar_fotos_perfil.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/deletar_usuario.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/editar_usuario.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/obter_usuario.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/sair_usuario.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/song/adicionar_ou_remover_musica_favorita.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/song/obter_lista_reproducao.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/song/obter_musicas_favoritas.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/song/obter_novas_musicas.dart';
import 'package:project_sound_wave/nucleo/service_locator.dart';
import 'package:project_sound_wave/nucleo/firebase_options.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/favoritos_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/novas_musicas_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/lista_reproducao_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/info_perfil_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/info_perfil_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Configuracoes/tema_bloc.dart';
import 'package:project_sound_wave/interface_grafica/telas/splash/pages/tela_inicial.dart';

Future<void> main() async {
  // Garante que os widgets do Flutter estejam inicializados e prontos para uso.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicializa as dependências do aplicativo usando o localizador de serviços (Service Locator).
  // Usados globalmente para acessar os casos de uso e outras dependências necessárias.
  await inicializarDependencias();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  /// Construtor para MyApp.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Cria uma instância única do BlocReprodutorMusica.
    // Esta instância será compartilhada entre os widgets que precisam acessar
    // as funcionalidades de reprodução de música.
    final audioBloc = BlocReprodutorMusica();

    return MultiBlocProvider(
      providers: [
        // Provedor para o TemaBloc.
        // Responsável por gerenciar o tema claro/escuro do aplicativo.
        BlocProvider(create: (context) => TemaBloc()),

        // Provedor para o FavoritosBloc.
        // Gerencia a lógica de adicionar/remover músicas favoritas e obter a lista de favoritas.
        BlocProvider(
          create:
              (context) => FavoritosBloc(
                adicionarOuRemoverFavorita:
                    localizadorDeServicos<
                      AdicionarOuRemoverMusicaFavoritaCasoDeUso
                    >(),
                obterFavoritas:
                    localizadorDeServicos<ObterMusicasFavoritasCasoDeUso>(),
              ),
        ),

        // Provedor para o ListaReproducaoBloc.
        // Gerencia a lista de reprodução atual.
        BlocProvider(
          create:
              (context) => ListaReproducaoBloc(
                obterListaReproducao:
                    localizadorDeServicos<ObterListaReproducaoCasoDeUso>(),
                adicionarOuRemoverFavorita:
                    localizadorDeServicos<
                      AdicionarOuRemoverMusicaFavoritaCasoDeUso
                    >(),
              ),
        ),

        // Provedor para o NovasMusicasBloc.
        // Responsável por buscar e gerenciar a lista de novas músicas disponíveis.
        BlocProvider(
          create:
              (context) => NovasMusicasBloc(
                localizadorDeServicos<ObterNovasMusicasCasoDeUso>(),
              ),
        ),

        // Provedor para o InfoPerfilBloc.
        // Gerencia as informações do perfil do usuário e dispara um evento inicial para carregar os dados.
        BlocProvider(
          create:
              (context) => InfoPerfilBloc(
                obterUsuarioCasoDeUso:
                    localizadorDeServicos<ObterUsuarioCasoDeUso>(),
              )..add(const InfoPerfilRequisicaoEvento()),
        ),

        // Provedor para o BlocReprodutorMusica.
        // Reutiliza a instância criada anteriormente para garantir que haja apenas uma instância do reprodutor de áudio.
        BlocProvider<BlocReprodutorMusica>.value(value: audioBloc),

        // Provedor para o DeleteUsuarioBloc.
        // Lida com a lógica de exclusão da conta do usuário.
        BlocProvider(
          create:
              (context) => DeleteUsuarioBloc(
                deletarUsuarioCasoDeUso:
                    localizadorDeServicos<DeletarUsuarioCasoDeUso>(),
              ),
        ),

        // Provedor para o SairUsuarioBloc.
        // Gerencia o processo de logout do usuário.
        BlocProvider(
          create:
              (context) => SairUsuarioBloc(
                sairUsuarioCasoDeUso:
                    localizadorDeServicos<SairUsuarioCasoDeUso>(),
              ),
        ),

        // Provedor para o EditarPerfilBloc.
        // Lida com a edição das informações do perfil do usuário.
        BlocProvider(
          create:
              (context) => EditarPerfilBloc(
                editarUsuarioCasoDeUso:
                    localizadorDeServicos<EditarUsuarioCasoDeUso>(),
              ),
        ),

        // Provedor para o BuscarFotosPerfilBloc.
        // Responsável por buscar e gerenciar as fotos de perfil do usuário.
        BlocProvider(
          create:
              (context) => BuscarFotosPerfilBloc(
                buscarFotosPerfilCasoDeUso:
                    localizadorDeServicos<BuscarFotosPerfilCasoDeUso>(),
              ),
        ),
      ],
      // O BlocBuilder reage a mudanças no estado do TemaBloc para reconstruir a UI com o tema correto.
      child: BlocBuilder<TemaBloc, TemaEstado>(
        builder: (context, state) {
          return MaterialApp(
            // Define o tema do aplicativo (claro ou escuro) com base no estado atual do TemaBloc.
            theme: state.dadosDoTema,
            // Remove o banner de depuração no canto superior direito.
            debugShowCheckedModeBanner: false,
            home: const PaginaTelaInicial(),
          );
        },
      ),
    );
  }
}
