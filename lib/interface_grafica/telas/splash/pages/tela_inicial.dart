import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_sound_wave/nucleo/configs/assets/vetores_app.dart';
import 'package:project_sound_wave/interface_grafica/telas/intro/pages/comecar.dart';

/// Página de splash (tela de abertura) do aplicativo.
class PaginaTelaInicial extends StatefulWidget {
  const PaginaTelaInicial({super.key});

  @override
  State<PaginaTelaInicial> createState() => _PaginaTelaInicialState();
}

class _PaginaTelaInicialState extends State<PaginaTelaInicial> {
  @override
  void initState() {
    super.initState();
    _redirecionar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // `SvgPicture.asset` é usado para exibir o logotipo do aplicativo.
        child: SvgPicture.asset(VetoresApp.logo),
      ),
    );
  }

  /// Redireciona para a página de introdução após um atraso predefinido.
  Future<void> _redirecionar() async {
    // Aguarda 2 segundos para que o usuário possa ver o logotipo do aplicativo.
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Navega para a `PaginaComecar`, substituindo a tela atual na pilha de navegação por causa do pushReplacement.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const PaginaComecar(),
      ),
    );
  }
}
