import 'package:flutter/material.dart';

/// Um botão de aplicativo básico e reutilizável.
///
/// Este widget fornece um botão elevado com um título e uma ação de pressionar.
class BotaoAppBasico extends StatelessWidget {
  /// A função a ser chamada quando o botão for pressionado.
  final VoidCallback aoPressionar;
  /// O texto a ser exibido no botão.
  final String titulo;
  /// A altura opcional do botão. Se nulo, a altura padrão será 80.
  final double? altura;

  const BotaoAppBasico({
    required this.aoPressionar,
    required this.titulo,
    this.altura,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: aoPressionar,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(altura ?? 80),
      ),
      child: Text(titulo),
    );
  }
}


