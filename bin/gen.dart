import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dyptsy/dyptsy.dart';
import 'package:dyptsy/entity/coin.e.dart';
import 'package:path/path.dart';
import 'package:html5lib/dom.dart';
import 'package:html5lib/parser.dart';

final String appRoot = dirname(dirname(Platform.script
  .toFilePath(windows: Platform.isWindows)));
final HttpClient client = new HttpClient();
final List<Coin> allCoins = <Coin>[];

class CoinData {
  final List<Coin> coins;
  final String marketName;
  /* Map is keyed by pair id */
  final Map<String, Pair> pairs;
  final Map<String, Pair> urls;
  
  CoinData (this.coins, this.marketName, this.pairs, this.urls);
  
  String toString () => '$coins\n$pairs';
}

Future<CoinData> coinSwapCoinData () {
  Completer<CoinData> c = new Completer<CoinData> ();
  StringBuffer buf = new StringBuffer ();
  client.getUrl(Uri.parse('https://coin-swap.net')).then((request) => 
      request.close()).then((response) {
    response.transform(UTF8.decoder).listen((String data) =>
        buf.write(data), onDone: () {
          Document doc = parse(buf.toString());
          //Save some memory
          buf.clear();
          
          Map<String, List<String>> infos = <String, List<String>>{};
          RegExp reg = new RegExp(r'https:\/\/coin-swap\.net(\/market\/(\w+)\/(\w+))');
          Function parser = (Element e) {
            Element a = e.nodes[1];
            String href = a.attributes['href'];
            //Needed later to get names of coins
            Match m = reg.firstMatch(href);
            infos[href] = <String>[m[1], m[2], m[3]];
          };
          //Getting needed elements (the one with 3 elements is the menu)
          Iterable<Element> es = doc.getElementsByClassName('nav navbar-nav')
              .where((e) => 3 < e.children.length);
          Element btcs = es.first;
          btcs.children.skip(1).forEach(parser);
          Element doges = es.elementAt(1);
          doges.children.skip(1).forEach(parser);
          
          List<Coin> coins = <Coin>[];
          RegExp pairReg = new RegExp(r'([A-Za-z0-9()]+(?:\s*[A-Za-z0-9()]+)*)\s*\/\s*([A-Za-z0-9()]+(?:\s*[A-Za-z0-9()]+)*)');
          Map<String, Pair> pairs = <String, Pair>{}, urls = <String, Pair>{};
          RegExp idReg = new RegExp(r'[a-z]-(\d+)');
          //Iterates all hrefs to get coins names. Avoids too many concurrent requests.
          Future.forEach(infos.keys, (String href) {
            //Returns a future when response completes
            return client.getUrl(Uri.parse(href)).then((request) => 
                request.close())
                  ..then((response) {
                    response.transform(UTF8.decoder).listen((data) => 
                        buf.write(data), onDone: () {
                          Document doc = parse(buf.toString());
                          //Save some memory
                          buf.clear();
                          Match id = idReg.firstMatch(doc
                              .getElementsByClassName('marketstats')[2]
                              .children[1].id);
                          Element div = doc.getElementById('marketname');
                          if (null != div) {
                            Match m = pairReg.firstMatch(div.nodes[3].text);
                            List<String> info = infos[href];
                            Coin first = allCoins.firstWhere((test) =>
                                test.name.toLowerCase() == fixName(m[1]).toLowerCase()
                                && test.shortName == info[2], orElse: () =>
                                    null);
                            if (null == first) {
                              first = new Coin(name: fixName(m[1]),
                                  shortName: info[1]);
                              allCoins.add(first);
                            }
                            if (!coins.contains(first)) {
                              coins.add(first);
                            }
                            Coin second = allCoins.firstWhere((test) =>
                                test.name.toLowerCase() == fixName(m[2]).toLowerCase()
                                && test.shortName == info[2], orElse: () =>
                                    null);
                            if (null == second) {
                              second = new Coin(name: fixName(m[2]),
                                  shortName: info[2]);
                              allCoins.add(second);
                            }
                            if (!coins.contains(second)) {
                              coins.add(second);
                            }
                            Pair p = new Pair(first, second);
                            pairs[id[1]] = p;
                            urls[info[0]] = p;
                          } else {
                            print('Warning $href not working');
                          }
                        });
            });
          }).then((_) => c.complete(new CoinData(coins, 'CoinSwap', pairs, urls)));
        });
  });
  return c.future;
}

Future<CoinData> cryptsyCoinData () {
  Completer<CoinData> c = new Completer<CoinData>();
  StringBuffer buf = new StringBuffer ();
  client.getUrl(Uri.parse('https://www.cryptsy.com/')).then((request) => 
      request.close()).then((response) {
    response.transform(UTF8.decoder).listen((String data) =>
        buf.write(data), onDone: () {
          Document doc = parse(buf.toString());
          //Save some memory
          buf.clear();
          //matchers
          RegExp codeReg = new RegExp(r'\s*(\w+)\/(\w+)'),
              idReg = new RegExp(r'\/markets\/view\/(\d+)'),
              pairReg = new RegExp(r'([A-Za-z0-9()/]+(?:\s*[A-Za-z0-9()/]+)*)\s*->\s*([A-Za-z0-9()]+(?:\s*[A-Za-z0-9()]+)*)');
          List<Coin> coins = <Coin>[];
          Map<String, Pair> pairs = <String, Pair>{}, urls = <String, Pair>{};
          Function parser = (Node n) {
            Element a = n.firstChild;
            Map<dynamic, String> attrs = a.attributes;
            //getting coins and pairs data
            Match code = codeReg.firstMatch(a.text);
            String url = attrs['href'];
            Match id = idReg.firstMatch(url);
            Match pair = pairReg.firstMatch(attrs['title']);
            Coin first = allCoins.firstWhere((test) => 
                test.name.toLowerCase() == fixName(pair[1]).toLowerCase() &&
                test.shortName == code[1], orElse: () => null);
            if (null == first) {
              first = new Coin(name: fixName(pair[1]), shortName: code[1]);
              allCoins.add(first);
            }
            if (!coins.contains(first)) {
              coins.add(first);
            }
            Coin second = allCoins.firstWhere((test) => 
                test.name.toLowerCase() == fixName(pair[2]).toLowerCase() &&
                test.shortName == code[2], orElse: () => null);
            if (null == second) {
              second = new Coin(name: fixName(pair[2]), shortName: code[2]);
              allCoins.add(second);
            }
            if (!coins.contains(second)) {
              coins.add(second);
            }
            Pair p = new Pair(first, second);
            pairs[id[1]] = p;
            urls[url] = p;
          };
          
          //Parsing USD pairs
          Element usds = doc.getElementById('leftusdlist');
          usds.children.forEach(parser);
          //Parsing BTC pairs
          Element btcs = doc.getElementById('leftbtclist');
          btcs.children.forEach(parser);
          //Parsing LTC pairs
          Element ltcs  = doc.getElementById('leftltclist');
          ltcs.children.forEach(parser);
          c.complete(new CoinData(coins, 'Cryptsy', pairs, urls));
        });
  });
  return c.future;
}

Future<CoinData> mintPalCoinData() {
  var c = new Completer<CoinData>();
  var buf = new StringBuffer();
  client.getUrl(Uri.parse('https://www.mintpal.com/market')).then((request) {
    //Unable to get non robot response  
    request.headers..add('User-Agent', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36')
        ..add('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8')..add('Connection', 'keep-alive')
        ..add('Accept-Encoding', 'gzip,deflate,sdch')..add('DNT', '1')
        ..add('Accept-Language', 'it-IT,it;q=0.8,en-US;q=0.6,en;q=0.4')
        ..add('Host', 'www.mintpal.com:443');
      return request.close();
    }).then((response) {
    response.transform(UTF8.decoder).listen((data) => buf.write(data),
      onDone: () {
        var doc = parse(buf.toString());
        //Save some memory
        print(buf.toString());
        buf.clear();
        
        Element btcs = doc.getElementById('btcMarkets');
        print(btcs.children.first.outerHtml);
        Element ltcs = doc.getElementById('ltcMarkets');
        
      });
  });
  return c.future;
}

Future<CoinData> poloniexCoinData () {
  Completer<CoinData> c = new Completer<CoinData>();
  StringBuffer buf = new StringBuffer();
  client.getUrl(Uri.parse('https://www.poloniex.com/exchange'))
    .then((request) => request.close()).then((response) {
    response.transform(UTF8.decoder).listen((data) => buf.write(data),
        onDone: () {
          Document doc = parse(buf.toString());
          //Save some memory
          buf.clear();
          
          RegExp idReg = new RegExp('\/exchange\/(\[a-z0-9()]+_\[a-z0-9()]+)'), 
              shortNameReg = new RegExp('marketLink(\[A-Za-z0-9()]+)_(\[A-Za-z0-9()]+)');
          List<Coin> coins = <Coin>[];
          Map<String, Pair> pairs = <String, Pair>{}, urls = <String, Pair> {};
          Function parser = (Element e) {
            Map<dynamic, String> attrs = e.attributes;
            String url = attrs['href'];
            Match id = idReg.firstMatch(url);
            Match shortName = shortNameReg.firstMatch(attrs['id']);
            Coin first = allCoins.firstWhere((test) => 
                test.name.toLowerCase() == fixName(attrs['data-currencyname'])
                  .toLowerCase() && test.shortName == shortName[2], 
                  orElse: () => null);
            if (null == first) {
              first = new Coin(name: fixName(attrs['data-currencyname']),
                  shortName: shortName[2]);
              allCoins.add(first);
            }
            if (!coins.contains(first)) {
              coins.add(first);
            }
            String sName = shortName[1];
            Coin second;
            switch (sName) {
              case 'BTC':
                second = allCoins.firstWhere((test) => 
                    test.name.toLowerCase() == 'bitcoin' &&
                    test.shortName == 'BTC', orElse: () => null);
                if (null == second) {
                  second = new Coin(name: 'BitCoin', shortName: 'BTC');
                  allCoins.add(second);
                }
                break;
              case 'XMR':
                second = allCoins.firstWhere((test) => 
                    test.name.toLowerCase() == 'monero' &&
                    test.shortName == 'XMR', orElse: () => null);
                if (null == second) {
                  second = new Coin(name: 'Monero', shortName: 'XMR');
                }
                break;
            }
            if (!coins.contains(second)) {
              coins.add(second);
            }
            Pair p = new Pair(first, second);
            pairs[id[1]] = p;
            urls[url] = p;
          };
          
          Element btcs = doc.getElementById('btcMarketsTable');
          btcs.children.forEach(parser);
          Element xmrs = doc.getElementById('xmrMarketsTable');
          xmrs.children.forEach(parser);
          
          c.complete(new CoinData(coins, 'Poloniex', pairs, urls));
    });
  });
  return c.future;
}

void generateSupportedCoin (String libraryName, String path,
                  CoinData data) {
  StringBuffer buf = new StringBuffer ();
  String libPath = join(appRoot, path);
  FileSystemEntity.type(libPath).then((type) {
    switch(type) {
      case FileSystemEntityType.DIRECTORY:
        buf..clear()..write('\nList<Coin> ${data.marketName}Coins = <Coin> [');
        data.coins.forEach((coin) {
          buf.write("\n  ${coin.name},");
        });
        String tmp = '${buf.toString().substring(0, buf.length - 1)}\n];';
        buf..clear()
            ..write('$tmp\n\nMap<Pair, String> ${data.marketName}Ids = <Pair, String> {');
        data.pairs.forEach((id, pair) {
          buf.write("\n  ${pair.first.name}_${pair.second.name}: '$id',");
        });
        tmp = '${buf.toString().substring(0, buf.length - 1)}\n};';
        buf..clear()..write('$tmp\n\nList<Pair> ${data.marketName}Pairs = <Pair> [');
        data.pairs.values.forEach((pair) {
          buf.write('\n  ${pair.first.name}_${pair.second.name},');
        });
        tmp = '${buf.toString().substring(0, buf.length - 1)}\n];';
        buf..clear()..write('$tmp\n\nMap <Pair, String> ${data.marketName}Urls = <Pair, String> {');
        data.urls.forEach((url, pair) {
          buf.write("\n  ${pair.first.name}_${pair.second.name}: '$url',");
        });
        tmp = '${buf.toString().substring(0, buf.length - 1)}\n};\n';
        buf..clear()..write(tmp);
        new File(join(libPath, 'coin.dart')).create().then((file) {
        file.writeAsString('''part of $libraryName;\n\n$buf''').then((_) => buf.clear());
        });
        break;
      default:
        throw new ArgumentError('Invalid path');
    }
  });  
}

void generateSupportedCoins (String libraryName, String path, List<CoinData> ds) {
  List<Coin> coins = <Coin>[];
  List<Pair> pairs = <Pair>[];
  ds.forEach((data) {
    String dir = join(appRoot, path, data.marketName.toLowerCase());
    new Directory(dir).createSync();
    generateSupportedCoin(libraryName, dir, data);
    data.coins.forEach((coin) {
      if (!coins.contains(coin)) {
        coins.add(coin);
      }
    });
    data.pairs.values.forEach((pair) {
      if (!pairs.contains(pair)) {
        pairs.add(pair);
      }
    });
  });
  StringBuffer buf = new StringBuffer ('''library $libraryName;
import 'package:dyptsy/entity/coin.e.dart';
import 'package:dyptsy/dyptsy.dart';\n\n''');
  ds.forEach((data) => buf.write("part '${data.marketName.toLowerCase()}/coin.dart';\n"));
  buf.write('\nfinal Coin');
  coins.forEach((coin) =>
      buf.write("\n  ${coin.name} = new Coin (name: '${coin.name
        .replaceAll('\$', '\\\$')}', shortName: '${coin.shortName}'),"));
  buf = new StringBuffer('${buf.toString().substring(0, buf.length - 1)};\n\nfinal List<Coin> AllCoins = <Coin>[');
  coins.forEach((coin) =>
      buf.write('\n  ${coin.name},'));
  buf = new StringBuffer('${buf.toString().substring(0, buf.length - 1)}\n];\n\nfinal Pair');
  pairs.forEach((pair) =>
      buf.write("\n  ${pair.first.name}_${pair.second.name} = new Pair (${pair.first.name}, ${pair.second.name}),"));
  buf = new StringBuffer('${buf.toString().substring(0, buf.length - 1)};\n\nfinal List<Pair> AllPairs = <Pair>[');
  pairs.forEach((pair) => 
      buf.write('\n  ${pair.first.name}_${pair.second.name},'));
  new File(join(appRoot, 'lib/coin/coin.dart')).writeAsStringSync('${buf.toString().substring(0, buf.length - 1)}\n];\n');
}

void main () {
  mintPalCoinData();
}

void _main () {
  List<CoinData> ds = <CoinData>[];
  Function dsAdd = (CoinData d) => ds.add(d);
  String lib = 'coin';
  Future.wait([coinSwapCoinData().then(dsAdd),
               cryptsyCoinData().then(dsAdd),
               poloniexCoinData().then(dsAdd)
               ]).then((_) {
    int i = 0;
    ds.forEach((data) {
      i++;
      data.coins.forEach((coin) {
        String namelc = coin.name.toLowerCase();
        ds.skip(i).forEach((_data) {
          Coin _coin = _data.coins.firstWhere((test) => 
              test.name.toLowerCase() == namelc, orElse: () => null);
          if (null != _coin) {
            if (coin.shortName == _coin.shortName) {
              _coin.name = coin.name;
            } else {
              _coin.name = '${_coin.name}\$${_data.marketName}';
              coin.name = '${coin.name}\$${data.marketName}';
            }
          }
        });
      });
    });
    i = 0;
    allCoins.forEach((coin) {
      Iterable<Coin> found = allCoins.where((test) => test != coin &&
          test.name.toLowerCase() == coin.name.toLowerCase());
      if (found.length != 0) {
        found.forEach((_coin) {
          _coin.name = '${_coin.name}${_coin.shortName}';
        });
        coin.name = '${coin.name}${coin.shortName}';
      }
    });
    generateSupportedCoins(lib, 'lib/coin', ds);
  });
}