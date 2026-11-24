import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_sound_wave/nucleo/configs/assets/imagens_app.dart';
import 'package:project_sound_wave/nucleo/configs/assets/vetores_app.dart';
import 'package:project_sound_wave/nucleo/configs/theme/cores_app.dart';
import 'package:project_sound_wave/interface_grafica/telas/choose_mode/pages/escolher_modo.dart';
import 'package:project_sound_wave/interface_grafica/componentes/button/botao_app_basico.dart';

class PaginaComecar extends StatelessWidget {
  const PaginaComecar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
        // Define a imagem de fundo para a tela de introdução, preenchendo todo o container.
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(ImagensApp.introBG),
          ),
        ),
        child: Column(
          children: [
            // Exibe o logotipo do aplicativo no topo da tela, centralizado horizontalmente.
            Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(VetoresApp.logo),
            ),
            const Spacer(), // Ocupa o espaço restante, empurrando o conteúdo para baixo.
            const Text(
              'Divirta-se ouvindo música',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 21),
            // Fornece uma breve descrição sobre o que o aplicativo oferece.
            const Text(
              'Descubra milhões de músicas, crie playlists perfeitas e curta seus artistas favoritos onde e quando quiser.',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: CoresApp.cinza,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 21),
            // Botão principal que inicia a navegação para a próxima tela.
            BotaoAppBasico(
              aoPressionar: () {
                // Navega para a `PaginaEscolherModo` e substitui a rota atual, impedindo o retorno a esta tela.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (BuildContext context) => const PaginaEscolherModo(),
                  ),
                );
              },
              titulo: 'Começar',
            ),
          ],
        ),
      ),
    );
  }
}
