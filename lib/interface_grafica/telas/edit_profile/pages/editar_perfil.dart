import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/buscar_fotos_perfil_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/buscar_fotos_perfil_estado.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/buscar_fotos_perfil_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/editar_perfil_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/editar_perfil_estado.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/editar_perfil_eventos.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/info_perfil_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/info_perfil_estado.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Perfil/info_perfil_eventos.dart';
import 'package:project_sound_wave/camada_dados/dominio/entities/profilePhoto/foto_usuario.dart';
import 'package:project_sound_wave/nucleo/configs/theme/cores_app.dart';

class PaginaEditarPerfil extends StatefulWidget {
  const PaginaEditarPerfil({super.key});

  @override
  State<PaginaEditarPerfil> createState() => _PaginaEditarPerfilState();
}

class _PaginaEditarPerfilState extends State<PaginaEditarPerfil> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();

  int _imagemSelecionada = 0;
  List<FotoPerfilEntidade> _fotosPerfil = [];

  bool _nomeValido = true;
  bool _emailValido = true;
  bool _emailFormatoValido = true;
  bool senhaVisivel = false;

  String? _urlImagemAtual;

  @override
  void initState() {
    super.initState();
    // Obter a imagem atual do usuário
    final estadoPerfil = context.read<InfoPerfilBloc>().state;
    if (estadoPerfil is InfoPerfilCarregado) {
      _urlImagemAtual = estadoPerfil.entidadeUsuario.urlImagem;
    }

    // Dispara o evento para buscar as fotos de perfil
    context.read<BuscarFotosPerfilBloc>().add(
      BuscarFotosPerfilRequisicaoEvento(),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _novaSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocListener(
      listeners: [
        BlocListener<EditarPerfilBloc, EditarPerfilEstado>(
          listener: (context, state) {
            if (state is EditarPerfilSucesso) {
              // Dispara a atualização das informações do perfil
              context.read<InfoPerfilBloc>().add(InfoPerfilRequisicaoEvento());

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Perfil atualizado com sucesso!'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            } else if (state is EditarPerfilFalha) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.mensagem),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        ),
        BlocListener<BuscarFotosPerfilBloc, BuscarFotosPerfilEstado>(
          listener: (context, state) {
            if (state is BuscarFotosPerfilCarregado) {
              setState(() {
                _fotosPerfil = state.fotos;
                // Encontrar o índice da imagem atual na lista
                if (_urlImagemAtual != null) {
                  final index = _fotosPerfil.indexWhere(
                    (foto) => foto.imageURL == _urlImagemAtual,
                  );
                  if (index != -1) {
                    _imagemSelecionada = index;
                  }
                }
              });
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Perfil'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildSelecaoImagem(),
                const SizedBox(height: 24),

                // Campo para nome
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome (opcional)',
                    prefixIcon: const Icon(Icons.person),
                    border: const OutlineInputBorder(),
                    errorBorder:
                        _nomeValido
                            ? null
                            : const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                  ),
                  onChanged: (_) => setState(() => _nomeValido = true),
                ),
                const SizedBox(height: 16),

                // Campo para email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email (opcional)',
                    prefixIcon: const Icon(Icons.email),
                    border: const OutlineInputBorder(),
                    errorBorder:
                        (!_emailValido || !_emailFormatoValido)
                            ? const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            )
                            : null,
                  ),
                  onChanged: (_) {
                    setState(() {
                      _emailValido = true;
                      _emailFormatoValido = true;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Campo para nova senha
                TextFormField(
                  controller: _novaSenhaController,
                  obscureText: !senhaVisivel,
                  decoration: InputDecoration(
                    labelText: 'Nova Senha (opcional)',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        senhaVisivel ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          senhaVisivel = !senhaVisivel;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Botões de ação
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        side: BorderSide(
                          color:
                              isDarkTheme ? Colors.white : CoresApp.cinzaEscuro,
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color:
                              isDarkTheme ? Colors.white : CoresApp.cinzaEscuro,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _validarEConfirmar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDarkTheme ? Colors.white : CoresApp.cinzaEscuro,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      child: Text(
                        'Confirmar',
                        style: TextStyle(
                          color:
                              isDarkTheme ? CoresApp.cinzaEscuro : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelecaoImagem() {
    return BlocBuilder<BuscarFotosPerfilBloc, BuscarFotosPerfilEstado>(
      builder: (context, state) {
        if (state is BuscarFotosPerfilCarregando) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BuscarFotosPerfilCarregado) {
          _fotosPerfil = state.fotos; // Atualiza a lista local
          if (_fotosPerfil.isEmpty) {
            return const Text('Nenhuma foto de perfil disponível');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Escolha sua foto de perfil:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _fotosPerfil.length,
                  itemBuilder: (context, index) {
                    final foto = _fotosPerfil[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _imagemSelecionada = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    _imagemSelecionada == index
                                        ? Border.all(
                                          color: CoresApp.primaria,
                                          width: 1.75,
                                        )
                                        : null,
                              ),
                              child: Opacity(
                                opacity:
                                    _imagemSelecionada == index ? 1.0 : 0.55,
                                child: ClipOval(
                                  child: Image.network(
                                    foto.imageURL,
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 130,
                                        height: 130,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                        child: const Icon(Icons.error),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              foto.name,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is BuscarFotosPerfilFalha) {
          return const Text('Erro ao carregar fotos de perfil');
        }
        return const SizedBox(); // Estado inicial
      },
    );
  }

  void _validarEConfirmar() {
    final nomePreenchido = _nomeController.text.trim().isNotEmpty;
    final emailPreenchido = _emailController.text.trim().isNotEmpty;
    final emailValido = _validarEmail(_emailController.text.trim());

    setState(() {
      _nomeValido = nomePreenchido || !emailPreenchido;
      _emailValido = emailPreenchido || !nomePreenchido;
      _emailFormatoValido = !emailPreenchido || emailValido;
    });

    if (emailPreenchido && !emailValido) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um email válido'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    _mostrarDialogoConfirmacao();
  }

  bool _validarEmail(String email) {
    if (email.isEmpty) return true;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _mostrarDialogoConfirmacao() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar alterações'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Digite sua senha atual para confirmar:'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha atual',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (_senhaController.text.isNotEmpty) {
                    Navigator.pop(context);
                    _enviarAlteracoes();
                  }
                },
                child: const Text('Confirmar'),
              ),
            ],
          ),
    );
  }

  void _enviarAlteracoes() {
    context.read<EditarPerfilBloc>().add(
      EditarPerfilRequisicaoEvento(
        novoNome:
            _nomeController.text.trim().isNotEmpty
                ? _nomeController.text.trim()
                : null,
        novoEmail:
            _emailController.text.trim().isNotEmpty
                ? _emailController.text.trim()
                : null,
        novaImageURL: _fotosPerfil[_imagemSelecionada].imageURL,
        novaSenha:
            _novaSenhaController.text.trim().isNotEmpty
                ? _novaSenhaController.text.trim()
                : null,
        senhaAtual: _senhaController.text,
      ),
    );
  }
}
