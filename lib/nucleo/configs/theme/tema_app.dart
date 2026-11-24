import 'package:flutter/material.dart';
import 'package:project_sound_wave/nucleo/configs/theme/cores_app.dart';

class TemaApp {
  static final temaClaro = ThemeData(
    // Define a cor primária do tema, usada em elementos de destaque.
    primaryColor: CoresApp.primaria,
    // Define a cor de fundo padrão para scaffolds no tema claro.
    scaffoldBackgroundColor: CoresApp.fundoClaro,
    // Indica que este é um tema claro, afetando o comportamento de alguns widgets.
    brightness: Brightness.light,
    // Define a família de fontes padrão para todo o aplicativo.
    fontFamily: 'Gabarito',
    // Personaliza o tema do slider, removendo o overlay padrão.
    sliderTheme: SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
    // Define o tema para os campos de entrada de texto (InputDecoration).
    inputDecorationTheme: InputDecorationTheme(
      // Campos de entrada serão preenchidos, mas com cor transparente.
      filled: true,
      fillColor: Colors.transparent,
      // Preenchimento interno para o conteúdo dos campos de entrada.
      contentPadding: const EdgeInsets.all(30),
      // Estilo do texto de dica (hintText) nos campos de entrada.
      hintStyle: const TextStyle(
        color: Color(0xff383838),
        fontWeight: FontWeight.w500,
      ),
      // Estilo da borda padrão para os campos de entrada.
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.white, width: 0.4),
      ),
      // Estilo da borda quando o campo de entrada está habilitado, mas não focado.
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black, width: 0.4),
      ),
    ),
    // Define o tema para os botões elevados (ElevatedButton).
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // Cor de fundo do botão elevado.
        backgroundColor: CoresApp.primaria,
        // Cor do texto e ícones do botão elevado.
        foregroundColor: Colors.white,
        // Elevação do botão (sombra).
        elevation: 0,
        // Estilo do texto do botão.
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        // Forma do botão com bordas arredondadas.
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
  );

  static final temaEscuro = ThemeData(
    // Define a cor primária do tema escuro.
    primaryColor: CoresApp.primaria,
    // Define a cor de fundo padrão para scaffolds no tema escuro.
    scaffoldBackgroundColor: CoresApp.fundoEscuro,
    // Indica que este é um tema escuro.
    brightness: Brightness.dark,
    // Define a família de fontes padrão.
    fontFamily: 'Gabarito',
    // Personaliza o tema do slider para o modo escuro.
    sliderTheme: SliderThemeData(
      overlayShape: SliderComponentShape.noOverlay,
      // Cor da trilha ativa do slider.
      activeTrackColor: const Color(0xffB7B7B7),
      // Cor da trilha inativa do slider com transparência.
      inactiveTrackColor: const Color.fromRGBO(128, 128, 128, 0.3),
      // Cor do polegar (thumb) do slider.
      thumbColor: const Color(0xffB7B7B7),
    ),
    // Define o tema para os campos de entrada de texto no modo escuro.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      // Estilo do texto de dica (hintText) para o tema escuro.
      hintStyle: const TextStyle(
        color: Color(0xffA7A7A7),
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.all(30),
      // Estilo da borda padrão para os campos de entrada no tema escuro.
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.white, width: 0.4),
      ),
      // Estilo da borda quando o campo de entrada está habilitado no tema escuro.
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.white, width: 0.4),
      ),
    ),
    // Define o tema para os botões elevados no modo escuro.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CoresApp.primaria,
        foregroundColor: Colors.white,
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
  );
}
