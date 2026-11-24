import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/reprodutor_musica_bloc.dart';
import 'package:project_sound_wave/camada_bloc/bloc/Musica_e_Reproducao/reprodutor_musica_events.dart';
import 'package:project_sound_wave/camada_dados/dados/models/auth/requisicao_criar_usuario.dart';
import 'package:project_sound_wave/camada_dados/dados/models/auth/requisicao_entrar_usuario.dart';
import 'package:project_sound_wave/camada_dados/dados/models/auth/usuario.dart';
import 'package:project_sound_wave/camada_dados/dados/models/profilePhoto/foto_usuario.dart';
import 'package:project_sound_wave/camada_dados/dominio/entities/auth/usuario.dart';
import 'package:project_sound_wave/camada_dados/dominio/entities/profilePhoto/foto_usuario.dart';

abstract class ServicoFirebaseAutenticacao {
  Future<Either> cadastrarUsuario(CriarUsuarioRequisicao requisicao);
  Future<Either> fazerLoginUsuario(LoginUsuarioRequisicao requisicao);
  Future<Either> buscarUsuarioLogado();
  Future<Either> deletarUsuario(String senhaDigitada);
  Future<Either> logoutUsuario();

  Future<Either> editarUsuario({
    String? novoNome,
    String? novoEmail,
    String? novaImageURL,
    String? novaSenha,
    required String senhaAtual,
  });

  Future<Either> buscarFotosDePerfil();
}

class ImplementacaodosServicosFirebaseAutenticacao
    extends ServicoFirebaseAutenticacao {
  @override
  Future<Either> fazerLoginUsuario(LoginUsuarioRequisicao requisicao) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: requisicao.email,
        password: requisicao.senha,
      );
      return const Right('Login realizado com sucesso');
    } on FirebaseAuthException catch (e) {
      String mensagem = '';

      if (e.code == 'invalid-email') {
        mensagem = 'Nenhum usuário encontrado para esse e-mail';
      } else if (e.code == 'invalid-credential') {
        mensagem = 'Senha incorreta para esse usuário';
      }

      return Left(mensagem);
    }
  }

  @override
  Future<Either> cadastrarUsuario(CriarUsuarioRequisicao requisicao) async {
    try {
      var resultado = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: requisicao.email,
            password: requisicao.senha,
          );

      FirebaseFirestore.instance
          .collection('Users')
          .doc(resultado.user?.uid)
          .set({
            'name': requisicao.nomeCompleto,
            'email': resultado.user?.email,
          });

      return const Right('Cadastro realizado com sucesso');
    } on FirebaseAuthException catch (e) {
      String mensagem = '';

      if (e.code == 'weak-password') {
        mensagem = 'A senha fornecida é muito fraca';
      } else if (e.code == 'email-already-in-use') {
        mensagem = 'Já existe uma conta com esse e-mail.';
      }

      return Left(mensagem);
    }
  }

  @override
  Future<Either> buscarUsuarioLogado() async {
    try {
      FirebaseAuth autenticacaoFirebase = FirebaseAuth.instance;
      FirebaseFirestore bancoDeDados = FirebaseFirestore.instance;

      var usuarioSnapshot =
          await bancoDeDados
              .collection('Users')
              .doc(autenticacaoFirebase.currentUser?.uid)
              .get();

      UsuarioModelo usuarioModelo = UsuarioModelo.fromJson(
        usuarioSnapshot.data()!,
      );
      UsuarioEntidade usuarioEntidade =
          usuarioModelo.converterModeloParaEntidade();

      return Right(usuarioEntidade);
    } catch (e) {
      return const Left('Ocorreu um erro ao buscar o usuário');
    }
  }

  @override
  Future<Either> logoutUsuario() async {
    try {
      final audioBloc = BlocReprodutorMusica();
      audioBloc.add(EventoResetarReprodutor());

      await FirebaseAuth.instance.signOut();
      return const Right('Logout realizado com sucesso');
    } catch (e) {
      return Left('Erro ao fazer logout: $e');
    }
  }

  @override
  Future<Either> deletarUsuario(String senhaDigitada) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        return const Left('Nenhum usuário logado');
      }

      final credenciais = EmailAuthProvider.credential(
        email: user.email!,
        password: senhaDigitada,
      );

      await user.reauthenticateWithCredential(credenciais);

      final userDoc = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid);

      final favorites = await userDoc.collection('Favorites').get();
      for (var doc in favorites.docs) {
        await doc.reference.delete();
      }

      await userDoc.delete();

      await user.delete();

      final audioBloc = BlocReprodutorMusica();
      audioBloc.add(EventoResetarReprodutor());

      return const Right('Usuário deletado com sucesso');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return const Left('Senha incorreta.');
      }
      return Left('Erro ao deletar usuário: ${e.message}');
    } catch (e) {
      return Left('Erro ao deletar usuário: $e');
    }
  }

  @override
  Future<Either> editarUsuario({
    String? novoNome,
    String? novoEmail,
    String? novaImageURL,
    String? novaSenha,
    required String senhaAtual,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return const Left('Nenhum usuário logado');
      }

      if (novoNome == null &&
          novoEmail == null &&
          novaImageURL == null &&
          novaSenha == null) {
        return const Left('Pelo menos um campo deve ser alterado');
      }

      final credencial = EmailAuthProvider.credential(
        email: user.email!,
        password: senhaAtual,
      );
      await user.reauthenticateWithCredential(credencial);

      final emailAtualizado = novoEmail ?? user.email;
      final nomeAtualizado = novoNome ?? user.displayName;
      final senhaAtualizada = novaSenha ?? senhaAtual;

      final userDoc = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid);
      final Map<String, dynamic> updates = {};

      if (novoNome != null) {
        updates['name'] = novoNome;
      }
      if (novoEmail != null) {
        updates['email'] = novoEmail;
      }
      if (novaImageURL != null) {
        updates['imageURL'] = novaImageURL;
      } else {
        final doc = await userDoc.get();
        if (!doc.data()!.containsKey('imageURL')) {
          updates['imageURL'] = '';
        }
      }

      if (updates.isNotEmpty) {
        await userDoc.update(updates);
      }

      if (novoEmail != null || novaSenha != null) {
        final novoCredencial = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailAtualizado!,
              password: senhaAtualizada,
            );

        if (nomeAtualizado != null) {
          await novoCredencial.user?.updateDisplayName(nomeAtualizado);
        }

        final dadosUsuario = await userDoc.get();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(novoCredencial.user?.uid)
            .set(dadosUsuario.data()!);

        final favoritosAntigos = await userDoc.collection('Favorites').get();

        for (var favorito in favoritosAntigos.docs) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(novoCredencial.user?.uid)
              .collection('Favorites')
              .doc(favorito.id)
              .set(favorito.data());
        }

        for (var favorito in favoritosAntigos.docs) {
          await userDoc.collection('Favorites').doc(favorito.id).delete();
        }

        await userDoc.delete();

        await user.delete();

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAtualizado,
          password: senhaAtualizada,
        );
      } else {
        if (novoNome != null) {
          await user.updateDisplayName(novoNome);
        }

        await user.reload();
      }

      return const Right('Dados do usuário atualizados com sucesso');
    } on FirebaseAuthException catch (e) {
      return Left('Erro ao editar usuário: ${e.message}');
    } catch (e) {
      return Left('Erro ao editar usuário: $e');
    }
  }

  @override
  Future<Either<String, List<FotoPerfilEntidade>>> buscarFotosDePerfil() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('profilePhoto')
              .orderBy('name')
              .get();

      final photos =
          snapshot.docs
              .map((doc) {
                try {
                  final data = doc.data() as Map<String, dynamic>;

                  final modelo = FotoPerfilModelo.fromJson(data);

                  return modelo;
                } catch (e) {
                  return null;
                }
              })
              .whereType<FotoPerfilModelo>()
              .map((model) {
                final entidade = model.toEntity();
                return entidade;
              })
              .toList();

      if (photos.isEmpty) {
        return Left('Nenhuma foto válida encontrada');
      }

      return Right(photos);
    } catch (e) {
      return Left('Erro ao acessar o Firestore');
    }
  }
}
