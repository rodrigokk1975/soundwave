import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_sound_wave/camada_dados/dados/models/auth/requisicao_criar_usuario.dart';
import 'package:project_sound_wave/nucleo/configs/assets/vetores_app.dart';
import 'package:project_sound_wave/interface_grafica/telas/home/pages/inicio.dart';
import 'package:project_sound_wave/interface_grafica/componentes/button/botao_app_basico.dart';
import 'package:project_sound_wave/camada_dados/dominio/usecases/auth/cadastrar.dart';
import 'package:project_sound_wave/nucleo/service_locator.dart';
import 'package:project_sound_wave/interface_grafica/telas/auth/pages/entrar.dart';

class PaginaRegistro extends StatefulWidget {
  const PaginaRegistro({super.key});

  @override
  PaginaRegistroState createState() => PaginaRegistroState();
}

class PaginaRegistroState extends State<PaginaRegistro> {
  bool _senhaVisivel = false;

  final TextEditingController _nomeCompletoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  void dispose() {
    _nomeCompletoController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar')),
      body: Column(
        children: [
          // Seção do logotipo na parte superior da tela.
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(VetoresApp.logo),
            ),
          ),
          // Seção principal com formulário de registro.
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 40,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Título da página de registro.
                    const Text(
                      'Crie já sua conta!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 21),
                    // Campo de texto para o nome completo.
                    TextField(
                      controller: _nomeCompletoController,
                      decoration: const InputDecoration(
                        labelText: 'Nome Completo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Campo de texto para o email.
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    // Campo de texto para a senha com opção de visibilidade.
                    TextField(
                      controller: _senhaController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: const OutlineInputBorder(),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(
                            icon: Icon(
                              _senhaVisivel
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _senhaVisivel = !_senhaVisivel;
                              });
                            },
                          ),
                        ),
                      ),
                      obscureText: !_senhaVisivel,
                    ),
                    const SizedBox(height: 16),
                    // Botão para criar a conta.
                    BotaoAppBasico(
                      aoPressionar: () async {
                        // Validação dos campos de entrada.
                        if (_nomeCompletoController.text.isEmpty ||
                            _emailController.text.isEmpty ||
                            _senhaController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor, preencha todos os campos',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        // Chama o caso de uso de cadastro para criar o usuário.
                        final resultado =
                            await localizadorDeServicos<CadastrarCasoDeUso>()
                                .chamar(
                                  parametros: CriarUsuarioRequisicao(
                                    nomeCompleto: _nomeCompletoController.text,
                                    email: _emailController.text,
                                    senha: _senhaController.text,
                                  ),
                                );

                        // Lida com o resultado do cadastro (sucesso ou erro).
                        resultado.fold(
                          (erro) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(erro.toString()),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          (sucesso) {
                            // Navega para a tela inicial após o cadastro bem-sucedido.
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PaginaInicial(),
                              ),
                              (route) => false,
                            );
                          },
                        );
                      },
                      titulo: 'Criar uma conta',
                    ),
                    const SizedBox(height: 16),
                    // Botão para navegar para a tela de login.
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaginaEntrar(),
                          ),
                        );
                      },
                      child: const Text('Já tem uma conta? Faça login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
