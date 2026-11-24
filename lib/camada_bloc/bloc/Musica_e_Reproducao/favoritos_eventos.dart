abstract class FavoritosEvento {}

class CarregarFavoritos extends FavoritosEvento {}

class AlternarFavorito extends FavoritosEvento {
  final String idMusica;
  AlternarFavorito(this.idMusica);
}
