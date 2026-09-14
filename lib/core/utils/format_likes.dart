/// Formatage partagé d'un nombre de likes — seule copie dans l'app.
String formatLikes(int likes) {
  if (likes >= 1000000) return '${(likes / 1000000).toStringAsFixed(1)}M';
  if (likes >= 1000) return '${(likes / 1000).toStringAsFixed(1)}k';
  return likes.toString();
}
