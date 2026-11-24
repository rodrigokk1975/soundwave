import "package:dartz/dartz.dart";
import "package:project_sound_wave/camada_dados/dados/sources/auth/servico_firebase_autenticacao.dart";
import "package:project_sound_wave/nucleo/service_locator.dart";

class EditarUsuarioCasoDeUso {
  Future<Either> chamar({
    String? novoNome,
    String? novoEmail,
    String? novaImageURL,
    String? novaSenha,
    required String senhaAtual,
  }) async {
    return await localizadorDeServicos<ServicoFirebaseAutenticacao>()
        .editarUsuario(
          novoNome: novoNome,
          novoEmail: novoEmail,
          novaImageURL: novaImageURL,
          novaSenha: novaSenha,
          senhaAtual: senhaAtual,
        );
  }
}
