abstract class ListaReproducaoEvento {}

class CarregarListaReproducao extends ListaReproducaoEvento {}

class AlternarMusicaFavorita extends ListaReproducaoEvento {
  final String idMusica;
  AlternarMusicaFavorita(this.idMusica);
}
