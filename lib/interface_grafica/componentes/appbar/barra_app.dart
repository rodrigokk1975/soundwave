import 'package:flutter/material.dart';

class BarraAppBasica extends StatelessWidget implements PreferredSizeWidget {
  final Widget? titulo;
  final Widget? acao;
  final Color? corDeFundo;
  final Widget? principal;

  const BarraAppBasica({
    this.titulo,
    this.acao,
    this.corDeFundo,
    this.principal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: corDeFundo ?? Colors.transparent,
      centerTitle: true,
      title: titulo ?? const Text(''),
      actions: [acao ?? Container()],
      leading: principal,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
