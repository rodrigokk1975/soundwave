import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/info_perfil_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/info_perfil_estado.dart';
import 'package:project_sound_wave/interface_grafica/telas/home/widgets/lista_de_reproducao.dart';
import 'package:project_sound_wave/interface_grafica/componentes/appbar/barra_app.dart';

/// **PaginaPerfil**
///
/// Esta classe representa a tela de perfil do usuário no aplicativo.
/// Ela é responsável por exibir as informações do perfil do usuário e uma lista de músicas curtidas.
///
/// **Funcionalidades Principais:**
/// - Exibição dinâmica das informações do usuário (nome, email, imagem de perfil) utilizando `BlocBuilder`.
/// - Tratamento de diferentes estados (carregando, carregado, erro) para a exibição das informações do perfil.
/// - Integração com a lista de reprodução para exibir as músicas favoritas do usuário.
class PaginaPerfil extends StatelessWidget {
  const PaginaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraAppBasica(
        titulo: const Text(
          'Perfil',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        corDeFundo:
            Theme.of(context).brightness == Brightness.dark
                ? const Color(0xff2C2B2B) // Cor para tema escuro
                : Colors.white, // Cor para tema claro
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **BlocBuilder para Gerenciamento de Estado do Perfil**
            // Este widget reage às mudanças de estado do `InfoPerfilBloc`
            // para exibir as informações do usuário de forma dinâmica.
            BlocBuilder<InfoPerfilBloc, InfoPerfilEstado>(
              builder: (context, state) {
                // **Estado de Carregamento:**
                // Exibe um indicador de progresso enquanto as informações do perfil estão sendo carregadas.
                if (state is InfoPerfilCarregando) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                // **Estado Carregado:**
                // Quando as informações são carregadas com sucesso, exibe o nome, email e imagem do usuário.
                else if (state is InfoPerfilCarregado) {
                  final usuario = state.entidadeUsuario;
                  return _informacoesPerfil(
                    context,
                    usuario.nomeCompleto,
                    usuario.email,
                    usuario.urlImagem ??
                        '', // Garante que a URL da imagem não seja nula
                  );
                }
                // **Estado de Erro:**
                // Em caso de falha no carregamento, exibe uma mensagem de erro.
                else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'Erro ao carregar informações do usuário',
                        style: TextStyle(
                          color: Colors.red,
                        ), // Destaca a mensagem de erro
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 30),
            // **Lista de Reprodução de Músicas Curtidas**
            // Este componente exibe as músicas que o usuário marcou como favoritas.
            ListaDeReproducao(
              titulo: 'Músicas curtidas',
              apenasMusicasFavoritas: true,
            ),
          ],
        ),
      ),
    );
  }

  /// **_informacoesPerfil**
  ///
  /// Este método privado constrói o widget que exibe as informações detalhadas do perfil do usuário.
  /// Inclui a imagem de perfil (ou um avatar padrão), nome e email.
  ///
  /// **Parâmetros:**
  /// - `context`: O BuildContext atual.
  /// - `nome`: O nome completo do usuário.
  /// - `email`: O endereço de email do usuário.
  /// - `urlImagem`: A URL da imagem de perfil do usuário. Pode ser vazia se não houver imagem.
  Widget _informacoesPerfil(
    BuildContext context,
    String nome,
    String email,
    String urlImagem,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(50),
          bottomLeft: Radius.circular(50),
        ),
        // Define a cor de fundo do container com base no tema (claro/escuro).
        color:
            Theme.of(context).brightness == Brightness.dark
                ? const Color(0xff2C2B2B) // Cor para tema escuro
                : Colors.white, // Cor para tema claro
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // **Exibição da Imagem de Perfil:**
            // Se uma URL de imagem for fornecida, exibe a imagem da rede.
            // Caso contrário, exibe um `CircleAvatar` com um ícone de pessoa padrão.
            urlImagem.isNotEmpty
                ? Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(urlImagem), // Carrega a imagem da URL
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                : CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
            const SizedBox(height: 15),
            // **Exibição do Email do Usuário**
            Text(
              email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ), // Adicionado estilo para o email
            ),
            const SizedBox(height: 10),
            // **Exibição do Nome Completo do Usuário**
            Text(
              nome,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
