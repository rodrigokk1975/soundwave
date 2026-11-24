import "package:dartz/dartz.dart";
import "package:project_sound_wave/camada_dados/dados/sources/song/servico_firebase_musica.dart";
import "package:project_sound_wave/nucleo/service_locator.dart";

class ObterNovasMusicasCasoDeUso {
  Future<Either> chamar() async {
    return await localizadorDeServicos<ServicoFirebaseMusica>()
        .buscarMusicasNovas();
  }
}
