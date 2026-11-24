import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_sound_wave/nucleo/configs/theme/cores_app.dart';

class BottomNavigationBarPersonalizado extends StatelessWidget {
  final int indiceAtual;
  final Function(int) onTap;

  const BottomNavigationBarPersonalizado({
    super.key,
    required this.indiceAtual,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: SizedBox(
        height: 66,
        child: BottomNavigationBar(
          currentIndex: indiceAtual,
          onTap: onTap,
          selectedItemColor: CoresApp.primaria,
          unselectedItemColor: Colors.grey,
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 2.0,
          ),
          selectedLabelStyle: const TextStyle(
            fontSize: 12.25,
            fontWeight: FontWeight.w600,
            height: 2.0,
          ),
          items: [
            // Item para a tela "Home".
            const BottomNavigationBarItem(
              icon: Icon(Iconsax.home, size: 25),
              activeIcon: Icon(Iconsax.home_2, size: 26),
              label: 'Home',
            ),
            // Item para a tela "Perfil".
            const BottomNavigationBarItem(
              icon: Icon(Iconsax.profile_circle, size: 25),
              activeIcon: Icon(Iconsax.profile_circle5, size: 26),
              label: 'Perfil',
            ),
            // Item para a tela "Configurações".
            BottomNavigationBarItem(
              icon: Icon(Iconsax.setting_2, size: 26),
              activeIcon: Transform.translate(
                offset: Offset(-13.8, 0),
                child: Icon(Iconsax.setting_25, size: 26),
              ),
              label: 'Configurações',
            ),
          ],
        ),
      ),
    );
  }
}
