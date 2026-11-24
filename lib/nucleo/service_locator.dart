import 'package:get_it/get_it.dart';

// Importações de Serviços e Casos de Uso
// Esta seção agrupa todas as dependências externas e internas necessárias para o Service Locator.
// A organização por tipo (serviços, casos de uso de autenticação, casos de uso de música)
// facilita a compreensão das responsabilidades de cada componente.

// Serviços
import 'package:project_sound_wave/camada_dados/dados/sources/auth/servico_firebase_autenticacao.dart';
import 'package:project_sound_wave/camada_dados/dados/sources/song/servico_firebase_musica.dart';

// Casos de Uso - Autenticação
// Estes casos de uso encapsulam a lógica de negócios relacionada à autenticação de usuários.
// Eles atuam como intermediários entre a interface do usuário e as fontes de dados de autenticação.
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/buscar_fotos_perfil.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/cadastrar.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/deletar_usuario.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/editar_usuario.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/entrar.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/obter_usuario.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/sair_usuario.dart';

// Casos de Uso - Músicas
// Estes casos de uso contêm a lógica de negócios para operações relacionadas a músicas,
// como reprodução, favoritos e listas de reprodução.
import 'package:project_sound_wave/camada_dados/dominio/usecases/song/adicionar_ou_remover_musica_favorita.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/song/e_musica_favorita.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/song/obter_lista_reproducao.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/song/obter_musicas_favoritas.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/song/obter_novas_musicas.dart';

/// Instância global do localizador de serviços (Service Locator) usando o pacote GetIt.
final localizadorDeServicos = GetIt.instance;

/// Função assíncrona para inicializar todas as dependências do aplicativo.
Future<void> inicializarDependencias() async {
  // Registro de Serviços Firebase
  // Aqui, as implementações concretas dos serviços de autenticação e música do Firebase
  // são registradas como Singletons. Isso significa que a mesma instância será
  // reutilizada em todo o aplicativo, evitando a recriação desnecessária de objetos.
  localizadorDeServicos.registerSingleton<ServicoFirebaseAutenticacao>(
    ImplementacaodosServicosFirebaseAutenticacao(),
  );
  localizadorDeServicos.registerSingleton<ServicoFirebaseMusica>(
    ImplementacaoDosServicosFirebaseMusica(),
  );

  // Registro de Casos de Uso - Autenticação
  localizadorDeServicos.registerSingleton<CadastrarCasoDeUso>(
    CadastrarCasoDeUso(),
  );
  localizadorDeServicos.registerSingleton<EntrarCasoDeUso>(EntrarCasoDeUso());
  localizadorDeServicos.registerSingleton<ObterUsuarioCasoDeUso>(
    ObterUsuarioCasoDeUso(),
  );
  localizadorDeServicos.registerSingleton<DeletarUsuarioCasoDeUso>(
    DeletarUsuarioCasoDeUso(),
  );
  localizadorDeServicos.registerSingleton<SairUsuarioCasoDeUso>(
    SairUsuarioCasoDeUso(),
  );
  localizadorDeServicos.registerSingleton<EditarUsuarioCasoDeUso>(
    EditarUsuarioCasoDeUso(),
  );
  localizadorDeServicos.registerSingleton<BuscarFotosPerfilCasoDeUso>(
    BuscarFotosPerfilCasoDeUso(),
  );

  // Registro de Casos de Uso - Músicas
  localizadorDeServicos.registerSingleton<ObterNovasMusicasCasoDeUso>(
    ObterNovasMusicasCasoDeUso(),
  );
  localizadorDeServicos.registerSingleton<ObterListaReproducaoCasoDeUso>(
    ObterListaReproducaoCasoDeUso(),
  );
  localizadorDeServicos
      .registerSingleton<AdicionarOuRemoverMusicaFavoritaCasoDeUso>(
        AdicionarOuRemoverMusicaFavoritaCasoDeUso(),
      );
  localizadorDeServicos.registerSingleton<EMusicaFavoritaCasoDeUso>(
    EMusicaFavoritaCasoDeUso(),
  );
  localizadorDeServicos.registerSingleton<ObterMusicasFavoritasCasoDeUso>(
    ObterMusicasFavoritasCasoDeUso(),
  );
}
