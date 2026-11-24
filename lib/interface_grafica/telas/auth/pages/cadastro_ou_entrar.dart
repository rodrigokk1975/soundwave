import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_sound_wave/nucleo/configs/assets/imagens_app.dart';
import 'package:project_sound_wave/nucleo/configs/assets/vetores_app.dart';
import 'package:project_sound_wave/nucleo/configs/theme/cores_app.dart';
import 'package:project_sound_wave/interface_grafica/telas/auth/pages/registro.dart';
import 'package:project_sound_wave/interface_grafica/telas/auth/pages/entrar.dart';
import 'package:project_sound_wave/interface_grafica/componentes/button/botao_app_basico.dart';

class PaginaCadastroOuEntrar extends StatelessWidget {
  const PaginaCadastroOuEntrar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Padrão superior direito do design.
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(VetoresApp.padraoSuperior),
          ),
          // Padrão inferior direito do design.
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(VetoresApp.padraoInferior),
          ),
          // Imagem de fundo para autenticação.
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(ImagensApp.authBG),
          ),
          // Conteúdo central da página.
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logotipo do aplicativo.
                  AspectRatio(
                    aspectRatio: 5,
                    child: SvgPicture.asset(VetoresApp.logo),
                  ),
                  const SizedBox(height: 55),
                  // Título principal da página.
                  const Text(
                    "Divirta-se ouvindo música",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 21),
                  // Descrição do aplicativo.
                  Text(
                    "SoundWave é um provedor de mídia e streaming de áudio",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? CoresApp.cinza.withValues(alpha: 0.5 * 255)
                              : Colors.black.withValues(alpha: 0.5 * 255),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  // Botões de ação (Registrar e Entrar).
                  Row(
                    children: [
                      // Botão para registrar.
                      Expanded(
                        flex: 1,
                        child: BotaoAppBasico(
                          aoPressionar: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (BuildContext context) =>
                                        const PaginaRegistro(),
                              ),
                            );
                          },
                          titulo: 'Registrar',
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Botão para entrar.
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size(double.infinity, 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (BuildContext context) =>
                                        const PaginaEntrar(),
                              ),
                            );
                          },
                          child: Text(
                            'Entrar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
