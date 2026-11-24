import "package:dartz/dartz.dart";
import "package:project_sound_wave/camada_dados/dados/sources/auth/servico_firebase_autenticacao.dart";
import "package:project_sound_wave/nucleo/service_locator.dart";

class DeletarUsuarioCasoDeUso {
  Future<Either> chamar(String senhaDigitada) async {
    return await localizadorDeServicos<ServicoFirebaseAutenticacao>()
        .deletarUsuario(senhaDigitada);
  }
}
