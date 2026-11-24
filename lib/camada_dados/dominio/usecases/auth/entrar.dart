import "package:dartz/dartz.dart";
import "package:project_sound_wave/camada_dados/dados/models/auth/requisicao_entrar_usuario.dart";
import "package:project_sound_wave/camada_dados/dados/sources/auth/servico_firebase_autenticacao.dart";
import "package:project_sound_wave/nucleo/service_locator.dart";

class EntrarCasoDeUso {
  Future<Either> chamar({required LoginUsuarioRequisicao parametros}) async {
    return localizadorDeServicos<ServicoFirebaseAutenticacao>()
        .fazerLoginUsuario(parametros);
  }
}
