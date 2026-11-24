import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/delete_usuario_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/delete_usuario_estado.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/delete_usuario_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/sair_usuario_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/sair_usuario_estado.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Autenticacao_e_Usuario/sair_usuario_eventos.dart';
import 'package:project_sound_wave/interface_grafica/telas/auth/pages/cadastro_ou_entrar.dart';
import 'package:project_sound_wave/interface_grafica/telas/edit_profile/pages/editar_perfil.dart';
import 'package:project_sound_wave/nucleo/configs/theme/cores_app.dart';

/// Página de configurações do aplicativo.
///
/// Permite editar perfil, excluir conta e sair do aplicativo.
class PaginaConfiguracoes extends StatefulWidget {
  const PaginaConfiguracoes({super.key});

  @override
  State<PaginaConfiguracoes> createState() => _PaginaConfiguracoesState();
}

class _PaginaConfiguracoesState extends State<PaginaConfiguracoes> {
  final TextEditingController _senhaController = TextEditingController();
  bool senhaVisivel = false;

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteUsuarioBloc, DeleteUsuarioEstado>(
          listener: (context, state) {
            if (state is DeleteUsuarioSucesso) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaginaCadastroOuEntrar(),
                ),
              );
            } else if (state is DeleteUsuarioFalha) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.mensagem)));
            }
          },
        ),
        BlocListener<SairUsuarioBloc, SairUsuarioEstado>(
          listener: (context, state) {
            if (state is SairUsuarioSucesso) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaginaCadastroOuEntrar(),
                ),
              );
            } else if (state is SairUsuarioFalha) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.mensagem)));
            }
          },
        ),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Configurações',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Seção da conta
              _buildSection(
                context,
                title: 'Conta',
                children: [
                  _buildListTile(
                    context,
                    title: 'Editar perfil',
                    onTap: () => _editarPerfil(context),
                  ),
                  _buildListTile(
                    context,
                    title: 'Excluir conta',
                    textColor: Colors.red,
                    onTap: () => _confirmarExclusaoConta(context),
                  ),
                ],
              ),

              // Espaçamento no final para o botão de sair
              const SizedBox(height: 40),

              Center(
                child: TextButton(
                  onPressed: () => _confirmarLogout(context),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        isDarkTheme ? CoresApp.cinzaEscuro : Colors.white,
                    backgroundColor:
                        isDarkTheme ? Colors.white : CoresApp.cinzaEscuro,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Sair', style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói uma seção de configurações com título e itens.
  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(children: children),
        ),
      ],
    );
  }

  /// Constrói um item da lista de configurações.
  Widget _buildListTile(
    BuildContext context, {
    required String title,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  /// Navega para a página de edição de perfil
  void _editarPerfil(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaginaEditarPerfil()),
    );
  }

  /// Exibe diálogo de confirmação para excluir conta.
  void _confirmarExclusaoConta(BuildContext context) {
    final deleteBloc = context.read<DeleteUsuarioBloc>();
    bool senhaVisivel = false; // Mova esta variável para dentro do método

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Excluir conta'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Digite sua senha para confirmar a exclusão da conta:',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _senhaController,
                    obscureText: !senhaVisivel,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          senhaVisivel
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            senhaVisivel = !senhaVisivel;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _senhaController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () {
                    final senha = _senhaController.text.trim();
                    if (senha.isNotEmpty) {
                      Navigator.pop(context);
                      deleteBloc.add(
                        DeleteUsuarioRequisicaoEvento(senhaDigitada: senha),
                      );
                      _senhaController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Digite sua senha para confirmar.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Excluir'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Exibe diálogo de confirmação para logout.
  void _confirmarLogout(BuildContext context) {
    final sairBloc = context.read<SairUsuarioBloc>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sair da conta'),
            content: const Text('Tem certeza que deseja sair da sua conta?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  sairBloc.add(SairUsuarioRequisicaoEvento());
                },
                child: const Text('Sair'),
              ),
            ],
          ),
    );
  }
}
