import 'package:shared_preferences/shared_preferences.dart';
import 'questionaire.dart';

class Exercises {

  //a kérdőív befejeésével a tárhely elmenti a push, pull, legs, core értékét valamire
  //itt változókba tároljuk az elmentett értéket => a workout class ennek lesz a meghosszabbítása
 

  var push = {
    '1': 'Fal Fekvőtámasz',
    '2': 'Asztal Fekvőtámasz',
    '3': 'Térd Fekvőtámasz',
    '4': 'Fekvőtámasz',
    '5': 'Feltett Lábbal Fekvő',
    '6': 'Tolóckodás',
  };

  var pull = {
    '1': 'Táskás/Súlyzós Evezés',
    '2': 'Alacsony Rudas Evezés',
    '3': 'Húzóckodás',
  };

  var legs = {
    '1': 'Kapaszkodással Guggolás',
    '2': 'Kapaszkodással Kitörés',
    '3': 'Guggolás',
    '4': 'Kitörés',
    '5': 'Guggolásból Ugrás',
    '6': 'Kitörésben Ugrás',
    '7': 'Oldalas Guggolás',
    '8': 'Bolgár Guggolás',
  };

  var core = {
    '1': 'Hasprés',
    '2': 'Superman',
  };

 late String? pushex;
  late String? legsex;
  late String? pullex;
  late String? coreex;



  void initializeExercises() {
    String pushe = (prefs?.getInt('pushe') ?? 0).toString();
    String legse = (prefs?.getInt('legse') ?? 0).toString();
    String coree = (prefs?.getInt('coree') ?? 0).toString();
    String pulle = (prefs?.getInt('pulle') ?? 0).toString();

    pushex = push[pushe];
    legsex = legs[legse];
    pullex = pull[pulle];
    coreex = core[coree];
  }


}


//probléma: egyszerre csak egy szetnél szeretnénk gyakorlatot váltani
//előbb lehet, meg kéne határozni az összes lépést, utána gondolkozni