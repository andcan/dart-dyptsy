part of dyptsy;


class Kraken extends Api  {
  Kraken () : super(publicUrl: 'https://api.kraken.com/0/public');
  
  Future<Map<String, KrakenAssetInfo>> assetInfo () {
    Completer<Map<String, KrakenAssetInfo>> c = new Completer<Map<String, KrakenAssetInfo>>();
    Api.Client.getUrl(Uri.parse('${publicUrl}/Assets'))
      .then((request) => request.close()).then((response) {
      response.transform(UTF8.decoder).transform(Api.JSON_DECODER)
        .listen((Map<String, dynamic> json) {
          if (json.containsKey('result')) {
            var result = json['result'];
            Map<String, KrakenAssetInfo> assets = <String, KrakenAssetInfo>{};
            if (result is Map<String, Map<String, dynamic>>) {
              result.forEach((name, asset) {
                assets[name] = new KrakenAssetInfo(asset);
              });
              c.complete(assets);
            } else {
              c.completeError('Invalid response');
            }
          } else {
            c.completeError(json['error']);
          }
        });
    });
    return c.future;
  }
  
  Future<Map<String, KrakenAssetPair>> assetPairs () {
      Completer<Map<String, KrakenAssetPair>> c = new Completer<Map<String, KrakenAssetPair>>();
      Api.Client.getUrl(Uri.parse('${publicUrl}/AssetPairs'))
        .then((request) => request.close()).then((response) {
        response.transform(UTF8.decoder).transform(Api.JSON_DECODER)
          .listen((Map<String, dynamic> json) {
            if (json.containsKey('result')) {
              var result = json['result'];
              Map<String, KrakenAssetPair> pairs = <String, KrakenAssetPair>{};
              if (result is Map<String, Map<String, dynamic>>) {
                result.forEach((name, asset) {
                  pairs[name] = new KrakenAssetPair(asset);
                });
                c.complete(pairs);
              } else {
                c.completeError('Invalid response');
              }
            } else {
              c.completeError(json['error']);
            }
          });
      });
      return c.future;
    }
  
  Future<KrakenServerTime> serverTime () {
    Completer<KrakenServerTime> c = new Completer<KrakenServerTime>();
    Api.Client.getUrl(Uri.parse('${publicUrl}/Time'))
      .then((request) => request.close()).then((response) {
      response.transform(UTF8.decoder).transform(Api.JSON_DECODER)
        .listen((Map<String, dynamic> json) {
          if (json.containsKey('result')) {
            c.complete(new KrakenServerTime(json['result']));
          } else {
            c.completeError(json['error']);
          }
        });
    });
    return c.future;
  }
  
  Future<Map<String, KrakenTicker>> ticker (List<String> pairs) {
      Completer<Map<String, KrakenTicker>> c = new Completer<Map<String, KrakenTicker>>();
      Api.Client.getUrl(Uri.parse('${publicUrl}/Ticker?pair=${pairs.join(',')}'))
        .then((request) => request.close()).then((response) {
        response.transform(UTF8.decoder).transform(Api.JSON_DECODER)
          .listen((Map<String, dynamic> json) {
            if (json.containsKey('result')) {
              var result = json['result'];
              Map<String, KrakenTicker> tickers = <String, KrakenTicker>{};
              if (result is Map<String, Map<String, dynamic>>) {
                result.forEach((name, ticker) {
                  tickers[name] = new KrakenTicker(ticker);
                });
                c.complete(tickers);
              } else {
                c.completeError('Invalid response');
              }
            } else {
              c.completeError(json['error']);
            }
          });
      });
      return c.future;
    }
}