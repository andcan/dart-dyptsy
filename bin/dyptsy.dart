import 'dart:async';
import 'dart:io';
import 'package:dyptsy/coin/coin.dart';
import 'package:dyptsy/dyptsy.dart';
import 'package:orm/orm.dart';
import 'package:sqljocky/sqljocky.dart';
import 'package:dyptsy/entity/coin.e.dart';

class Report {
  
  Report (Pair this.pair);
  
  final Pair pair;
  Values coinSwap;
  Values cryptsy;
  Values poloniex;
  
  String toString () => '''${'${pair.first.name}(${pair.first.shortName})'}/${'${pair.second.name}(${pair.second.shortName})'}
  cryptsy : 
    $cryptsy
  poloniex: 
    $poloniex''';
}

class Values {
  Values(num this.average, num this.highestBid, num this.last,
      num this.lowestOffer);
  
  final num average;
  final num highestBid;
  final num last;
  final num lowestOffer;
  
  String toString () => '''
      average : $average
      high    : $highestBid
      last    : $last
      low     : $lowestOffer
''';
}

void main () {
  CoinSwap coinswap = new CoinSwap();
  Cryptsy cryptsy = new Cryptsy();
  Poloniex poloniex = new Poloniex();
  
  //coinswap.summary().then((csmd) {
    cryptsy.generalMarketData().then((cmd) {
      poloniex.returnTicker().then((pmd) {
        List<Future> fs = <Future>[];
        List<Report> reports = <Report>[];
        AllPairs.forEach((pair) {
          Report r = new Report (pair);
          reports.add(r);
          /*if (coinswap.supportedPairs.contains(pair)) {
            var found = csmd.values.where((test) => 
                test.symbol == pair.first.shortName);
            switch (found.length) {
              case 0:
                print('CoinSwap did not find $pair');
                break;
              case 1:
                SummaryData sd = found.first;
                r.coinSwap = new Values(null, sd.bid, sd.lastPrice, sd.ask);
                break;
              default:
                print('CoinSwap: Too many results');
                break;
            }
          }*/
          if (cryptsy.supportedPairs.contains(pair)) {
            var data = cmd['${pair.first.shortName}/${pair.second.shortName}'];
            if (null != data) {
              data.buyOrders.sort((o, o1) => o1.price < o.price ? -1 : 1);
              data.sellOrders.sort((o, o1) => o.price < o1.price ? -1 : 1);
              var buys = data.buyOrders;
              var sells = data.sellOrders;
              r.cryptsy = new Values(null, buys.isEmpty ? null : buys.first.price, 
                  data.lastTradePrice, sells.isEmpty ? null : sells.first.price);
            } else {
              print ('cryptsy di not find $pair');
            }
          }
          if (poloniex.supportedPairs.contains(pair)) {
            var data = pmd['${pair.second.shortName}_${pair.first.shortName}'];
            if (null != data) {
              r.poloniex = new Values(null, data.highestBid, data.last, 
                  data.lowestAsk);
            } else {
              print ('poloniex did not find $pair');
            }
          }
        });
        Future.wait(fs).then((_) {
          int nulls;
          reports.where((test) {
            nulls = 0;
            null == test.coinSwap ? nulls++ : null;
            null == test.cryptsy ? nulls++ : null;
            null == test.poloniex ? nulls++ : null;
            return nulls < 2;
          }).forEach((r) => print(r));
        });
      });
    });
  //});
}