import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_sound_wave/nucleo/configs/assets/imagens_app.dart';
import 'package:project_sound_wave/nucleo/configs/assets/vetores_app.dart';
import 'package:project_sound_wave/nucleo/configs/theme/cores_app.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Configuracoes/tema_bloc.dart';
import 'package:project_sound_wave/interface_grafica/telas/auth/pages/cadastro_ou_entrar.dart';
import 'package:project_sound_wave/interface_grafica/componentes/button/botao_app_basico.dart';

class PaginaEscolherModo extends StatefulWidget {
  const PaginaEscolherModo({super.key});

  @override
  State<PaginaEscolherModo> createState() => _PaginaEscolherModoState();
}

/// Estado da [PaginaEscolherModo].
class _PaginaEscolherModoState extends State<PaginaEscolherModo> {
  late bool estaModoEscuro;

  @override
  void initState() {
    super.initState();
    // Obtém o tema atual do TemaBloc e define o estado inicial de estaModoEscuro.
    final temaAtual = BlocProvider.of<TemaBloc>(context).state.dadosDoTema;
    estaModoEscuro = temaAtual.brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    // Obtém a instância do TemaBloc.
    final temaBloc = BlocProvider.of<TemaBloc>(context);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(ImagensApp.escolherModoBG),
          ),
        ),
        child: Column(
          children: [
            // Logotipo do aplicativo no topo.
            Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(VetoresApp.logo),
            ),
            const Spacer(),
            // Título da seção de escolha de modo.
            const Text(
              'Escolher modo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 21),
            // Opções de modo escuro e modo claro.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Opção para Modo Escuro.
                GestureDetector(
                  onTap: () {
                    setState(() {
                      estaModoEscuro = true;
                    });
                    // Dispara o evento de mudança de tema para o TemaBloc.
                    temaBloc.add(TemaAlterado(eEscuro: estaModoEscuro));
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              estaModoEscuro
                                  ? CoresApp.primaria.withValues(
                                    alpha: 0.8 * 255,
                                  )
                                  : const Color(
                                    0xff30393C,
                                  ).withValues(alpha: 0.625 * 255),
                        ),
                        child: SvgPicture.asset(
                          VetoresApp.lua,
                          fit: BoxFit.none,
                          colorFilter: ColorFilter.mode(
                            estaModoEscuro ? Colors.white : CoresApp.cinza,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Modo Escuro',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Opção para Modo Claro.
                GestureDetector(
                  onTap: () {
                    setState(() {
                      estaModoEscuro = false;
                    });
                    // Dispara o evento de mudança de tema para o TemaBloc.
                    temaBloc.add(TemaAlterado(eEscuro: estaModoEscuro));
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              !estaModoEscuro
                                  ? CoresApp.primaria.withValues(
                                    alpha: 0.8 * 255,
                                  )
                                  : const Color(
                                    0xff30393C,
                                  ).withValues(alpha: 0.625 * 255),
                        ),
                        child: SvgPicture.asset(
                          VetoresApp.sol,
                          fit: BoxFit.none,
                          colorFilter: ColorFilter.mode(
                            !estaModoEscuro ? Colors.white : CoresApp.cinza,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Modo Claro',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            // Botão para continuar para a próxima tela.
            BotaoAppBasico(
              aoPressionar: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaginaCadastroOuEntrar(),
                  ),
                );
              },
              titulo: 'Continuar',
            ),
          ],
        ),
      ),
    );
  }
}
