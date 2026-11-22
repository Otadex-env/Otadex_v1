/// Correspondance « tolérante » pour la recherche : accents ignorés, écritures
/// japonaises équivalentes, petites fautes de frappe acceptées.
///
/// Pourquoi : peu d'utilisateurs connaissent l'orthographe exacte d'un nom
/// japonais. « kiotaka » doit retrouver « Kiyotaka », « gojou » doit retrouver
/// « Gojo », « shonen » doit retrouver « Shōnen ».
library;

const _accentFrom = 'àâäáãåçéèêëíìîïñóòôöõøúùûüýÿōūāīē';
const _accentTo = 'aaaaaaceeeeiiiinoooooouuuuyyouaie';

/// Minuscules sans accents, 1 caractère → 1 caractère : les positions restent
/// valides, ce qui permet de surligner la saisie dans le texte d'origine.
String foldAccents(String s) {
  final b = StringBuffer();
  for (final ch in s.toLowerCase().split('')) {
    final i = _accentFrom.indexOf(ch);
    b.write(i == -1 ? ch : _accentTo[i]);
  }
  return b.toString();
}

/// Forme « phonétique » pour comparer : unifie les variantes courantes du
/// japonais écrit en lettres latines (shou/sho/shō, uu/u, oo/ou/o, tsu/tu…) et
/// les doubles consonnes. Appliquée à la saisie ET aux noms, avec des règles
/// qui ne dépendent pas de la lettre suivante : une saisie partielle (« sh »,
/// « ts ») reste donc cohérente avec le nom complet.
String phonetic(String s) {
  var t = foldAccents(s);
  t = t
      .replaceAll('sh', 's')
      .replaceAll('ch', 'c')
      .replaceAll('ts', 't')
      .replaceAll('ck', 'k')
      .replaceAll('ou', 'o')
      .replaceAll('oo', 'o')
      .replaceAll('uu', 'u')
      .replaceAll('ee', 'e');
  // Doubles consonnes : « kokkuri » = « kokuri ».
  return t.replaceAllMapped(
      RegExp(r'([b-df-hj-np-tv-z])\1'), (m) => m.group(1)!);
}

final _wordSplit = RegExp(r'[\s\-_:·.,]+');

/// Distance de Levenshtein (nombre de lettres à ajouter / enlever / changer).
int _levenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  var prev = List<int>.generate(b.length + 1, (i) => i);
  for (var i = 1; i <= a.length; i++) {
    final cur = List<int>.filled(b.length + 1, 0)..[0] = i;
    for (var j = 1; j <= b.length; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      var v = prev[j] + 1; // suppression
      if (cur[j - 1] + 1 < v) v = cur[j - 1] + 1; // ajout
      if (prev[j - 1] + cost < v) v = prev[j - 1] + cost; // remplacement
      cur[j] = v;
    }
    prev = cur;
  }
  return prev[b.length];
}

/// Nombre de fautes tolérées selon la longueur de la saisie (0 en dessous de
/// 4 lettres : trop de faux positifs).
int _allowedTypos(int len) => len >= 7 ? 2 : (len >= 4 ? 1 : 0);

/// Score de [name] pour la saisie [query] — plus petit = meilleur, -1 = aucun
/// rapport.
///
/// 0 le nom commence par la saisie · 1 un mot du nom commence par la saisie ·
/// 3 la saisie est ailleurs dans le nom · 4, 5, 6 : correspond à 0, 1 ou 2
/// fautes de frappe près.
int matchScore(String name, String query) {
  final q = phonetic(query.trim());
  if (q.isEmpty) return -1;
  final n = phonetic(name);
  if (n.startsWith(q)) return 0;
  final words = n.split(_wordSplit).where((w) => w.isNotEmpty).toList();
  if (words.any((w) => w.startsWith(q))) return 1;
  if (n.contains(q)) return 3;

  final maxTypos = _allowedTypos(q.length);
  if (maxTypos == 0) return -1;
  var best = maxTypos + 1;
  void compare(String target) {
    if ((target.length - q.length).abs() > maxTypos) return;
    final d = _levenshtein(q, target);
    if (d < best) best = d;
  }

  for (final w in words) {
    compare(w); // faute dans un mot entier
    if (w.length > q.length) compare(w.substring(0, q.length)); // saisie partielle
  }
  // Saisie de plusieurs mots (« killua zoldik ») : on compare au début du nom.
  if (n.length >= q.length) compare(n.substring(0, q.length));
  return best <= maxTypos ? 4 + best : -1;
}

/// Meilleure correction possible de [query] parmi [names] (« Vouliez-vous
/// dire… »), ou `null` si la saisie correspond déjà exactement à quelque chose
/// ou si rien n'est assez proche.
String? didYouMean(Iterable<String> names, String query) {
  String? bestName;
  var bestScore = 99;
  for (final name in names) {
    final s = matchScore(name, query);
    if (s == -1) continue;
    if (s < 4) return null; // la saisie est correcte : rien à corriger
    if (s < bestScore) {
      bestScore = s;
      bestName = name;
    }
  }
  return bestName;
}
