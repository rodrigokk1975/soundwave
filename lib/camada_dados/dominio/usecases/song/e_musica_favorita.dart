import "package:project_sound_wave/camada_dados/dados/sources/song/servico_firebase_musica.dart";
import "package:project_sound_wave/nucleo/service_locator.dart";

class EMusicaFavoritaCasoDeUso {
  Future<bool> chamar({required String parametros}) async {
    return await localizadorDeServicos<ServicoFirebaseMusica>()
        .verificarSeMusicaFavorita(parametros);
  }
}
