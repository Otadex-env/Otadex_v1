import 'package:flutter_test/flutter_test.dart';
import 'package:otadex/core/utils/search_match.dart';

void main() {
  group('matchScore', () {
    test('préfixe, mot, contient', () {
      expect(matchScore('Kiyotaka Ayanokoji', 'kiy'), 0);
      expect(matchScore('Killua Zoldyck', 'zol'), 1);
      expect(matchScore('Satoru Gojo', 'oru'), 3);
    });

    test('faute de frappe : le cas du testeur', () {
      expect(matchScore('Kiyotaka Ayanokoji', 'kiotaka'), greaterThanOrEqualTo(4));
      expect(matchScore('Killua Zoldyck', 'killua zoldik'), greaterThanOrEqualTo(4));
    });

    test('écritures japonaises équivalentes', () {
      expect(matchScore('Satoru Gojo', 'gojou'), lessThan(4));
      expect(matchScore('Shōnen', 'shounen'), lessThan(4));
      expect(matchScore('Shōnen', 'syonen'), greaterThanOrEqualTo(4)); // 1 faute
      expect(matchScore('Tsukasa', 'tukasa'), lessThan(4));
    });

    test('accents ignorés', () {
      expect(matchScore('Édouard', 'edou'), 0);
    });

    test('pas de faux positif sur saisies courtes ou sans rapport', () {
      expect(matchScore('Kiyotaka', 'zzz'), -1);
      expect(matchScore('Kiyotaka', 'kio'), -1); // 3 lettres : pas de tolérance
      expect(matchScore('Naruto Uzumaki', 'boruto'), -1);
    });
  });

  group('didYouMean', () {
    const names = ['Kiyotaka Ayanokoji', 'Killua Zoldyck', 'Satoru Gojo'];

    test('propose la correction', () {
      expect(didYouMean(names, 'kiotaka'), 'Kiyotaka Ayanokoji');
      expect(didYouMean(names, 'zoldik'), 'Killua Zoldyck');
    });

    test('rien à corriger si la saisie est déjà bonne', () {
      expect(didYouMean(names, 'kiyotaka'), isNull);
    });

    test('rien si trop éloigné', () {
      expect(didYouMean(names, 'abcdefg'), isNull);
    });
  });

  test('foldAccents garde la longueur', () {
    expect(foldAccents('Shōnen').length, 'Shōnen'.length);
    expect(foldAccents('Shōnen'), 'shonen');
  });
}
