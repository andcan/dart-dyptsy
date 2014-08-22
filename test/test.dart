import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dyptsy/dyptsy.dart';
import 'package:dyptsy/entity/coin.e.dart';
import 'package:unittest/unittest.dart';

class DoubleMatcher extends Matcher {
  
  const DoubleMatcher() : super();
  
  bool matches(item, Map matchState) {
    return item is double;
  }
  
  Description describe(Description description) =>
    description.add('double value');
}

class IntMatcher extends Matcher {
  
  const IntMatcher() : super();
  
  bool matches(item, Map matchState) {
    return item is int;
  }
  
  Description describe(Description description) =>
    description.add('int value');
}

class NumMatcher extends Matcher {
  
  const NumMatcher() : super();
  
  bool matches(item, Map matchState) {
    return item is num;
  }
  
  Description describe(Description description) =>
    description.add('numeric value');
}

class StringMatcher extends Matcher {
  
  const StringMatcher() : super();
  
  bool matches(item, Map matchState) {
    return item is String;
  }
  
  Description describe(Description description) =>
    description.add('String value');
}

const Matcher isDouble = const DoubleMatcher();
const Matcher isInt = const IntMatcher();
const Matcher isNum = const NumMatcher();
const Matcher isString = const StringMatcher();

void main () {
  test('Cryptsy', () {
    Cryptsy c = new Cryptsy();
    Future.forEach(c.supportedPairs, (Pair pair) {
      return c.generalMarketData(pair)
        ..then(expectAsync((Map<String, CryptsyMarketData> map) {
          map.forEach((name, m) {
            expect(m.buyOrders, isNotNull);
            expect(m.label, isNotNull);
            expect(m.lastTradePrice, isNotNull);
            expect(m.lastTradeTime, isNotNull);
            expect(m.marketId, isNotNull);
            expect(m.primaryCode, equals(pair.first.shortName));
            String name = fixName(m.primaryName);
            print (name);
            expect(name, equals(pair.first.name.substring(0, name.length)));//Avoids test fail when market name is appended to avoid conflicts
            expect(m.recentTrades, isNotNull);
            expect(m.secondaryCode, equals(pair.second.shortName));
            name = fixName(m.secondaryName);
            expect(name, equals(pair.second.name.substring(0, name.length)));//Avoids test fail when market name is appended to avoid conflicts
            expect(m.sellOrders, isNotNull);
            expect(m.volume, isNotNull);
          });
        }), onError: (e) => logMessage(pair.toString()));
    }).then(expectAsync((_) {
      logMessage('Done');
    }));
  });
  
  test ('CoinSwap', () {
    CoinSwap cs = new CoinSwap();
    cs.summary().then((ss) {
      
    });
  });
  
  /*test ('Kraken', () {
    Kraken k = new Kraken();
    k.assetInfo().then(expectAsync((Map<String, KrakenAssetInfo> info) {
      info.forEach((name, a) {
        
      });
    }));
    k.assetPairs().then(expectAsync((pairs) {
      print (pairs);
    }));
    k.serverTime().then(expectAsync((time) {
      print (time);
    }));
    k.ticker(['XLTCXXDG']).then(expectAsync((ticker) {
      print (ticker);
    }));
  });*/
}