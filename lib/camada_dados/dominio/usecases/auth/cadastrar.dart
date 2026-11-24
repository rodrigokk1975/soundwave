import "package:dartz/dartz.dart";
import "package:project_sound_wave/camada_dados/dados/models/auth/requisicao_criar_usuario.dart";
import "package:project_sound_wave/camada_dados/dados/sources/auth/servico_firebase_autenticacao.dart";
import "package:project_sound_wave/nucleo/service_locator.dart";

class CadastrarCasoDeUso {
  Future<Either> chamar({required CriarUsuarioRequisicao parametros}) async {
    return localizadorDeServicos<ServicoFirebaseAutenticacao>()
        .cadastrarUsuario(parametros);
  }
}
