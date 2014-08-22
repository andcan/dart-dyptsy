part of dyptsy;

class Pair {
  Pair(Coin this.first, Coin this.second);
  
  final Coin first;
  final Coin second;
  
  int get hashCode {
    int hash = 1;
    hash = 37 * hash + first.hashCode;
    hash = 37 * hash + second.hashCode;
    return hash;
  }
  
  bool operator == (Pair p) => first == p.first && second == p.second;
  
  String toString () => '''{'$first', '$second'}''';
}

Coin coinForName (String name) => AllCoins.firstWhere((test) 
    => name == test.name, orElse: () => null);

Coin coinForShortName (String name) => AllCoins.firstWhere((test) 
    => name == test.shortName, orElse: () => null);

const Map<String, String> numbers = const <String, String> {
  '0': 'Zero',
  '1': 'One',
  '2': 'Two',
  '3': 'Three',
  '4': 'Four',
  '5': 'Five',
  '6': 'Six',
  '7': 'Seven',
  '8': 'Eight',
  '9': 'Nine',
  '10': 'Ten',
  '11': 'Eleven',
  '12': 'Twelve',
  '13': 'ThirTeen',
  '14': 'FourTeen',
  '15': 'FifTeen',
  '16': 'SixTeen',
  '17': 'SevenTeen',
  '18': 'EighTeen',
  '19': 'NineTeen',
  '20': 'Twenty',
  '21': 'TwentyOne',
  '22': 'TwentyTwo',
  '23': 'TwentyThree',
  '24': 'TwentyFour',
  '25': 'TwentyFive',
  '26': 'TwentySix',
  '27': 'TwentySeven',
  '28': 'TwentyEight',
  '29': 'TwentyNine',
  '30': 'Thirty',
  '31': 'ThirtyOne',
  '32': 'ThirtyTwo',
  '33': 'ThirtyThree',
  '34': 'ThirtyFour',
  '35': 'ThirtyFive',
  '36': 'ThirtySix',
  '37': 'ThirtySeven',
  '38': 'ThirtyEight',
  '39': 'ThirtyNine',
  '40': 'Fourty',
  '41': 'FourtyOne',
  '42': 'FourtyTwo',
  '43': 'FourtyThree',
  '44': 'FourtyFour',
  '45': 'FourtyFive',
  '46': 'FourtySix',
  '47': 'FourtySeven',
  '48': 'FourtyEight',
  '49': 'FourtyNine',
  '50': 'Fifty',
  '51': 'FiftyOne',
  '52': 'FiftyTwo',
  '53': 'FiftyThree',
  '54': 'FiftyFour',
  '55': 'FiftyFive',
  '56': 'FiftySix',
  '57': 'FiftySeven',
  '58': 'FiftyEight',
  '59': 'FiftyNine',
  '60': 'Sixty',
  '61': 'SixtyOne',
  '62': 'SixtyTwo',
  '63': 'SixtyThree',
  '64': 'SixtyFour',
  '65': 'SixtyFive',
  '66': 'SixtySix',
  '67': 'SixtySeven',
  '68': 'SixtyEight',
  '69': 'SixtyNine'
};
RegExp matchDot = new RegExp(r'\.'), matchInvalid = new RegExp (r'[ (),-/]'), 
  matchNum = new RegExp(r'^(\d+)');
String fixName (String name) {
  name = name.replaceAll(matchInvalid, '').replaceAll(matchDot, 'Dot');
  Match m = matchNum.firstMatch(name);
  return null == m ? name : name.replaceAll(matchNum, numbers[m[1]]) ;
}