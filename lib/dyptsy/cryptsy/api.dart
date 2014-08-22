part of dyptsy;

class Cryptsy extends Api {
  Cryptsy();
  
  String get publicUrl => 'http://pubapi.cryptsy.com/api.php';
  List<Coin> get supportedCoins => CryptsyCoins;
  List<Pair> get supportedPairs => CryptsyPairs;
  
  Future<Map<String, CryptsyOrderData>> generalOrderBookData ([Pair pair]) {
    Completer<Map<String, CryptsyOrderData>> c = 
        new Completer<Map<String, CryptsyOrderData>> ();
    String uri = null == pair ? '$publicUrl?method=orderdatav2' 
        : '$publicUrl?method=singleorderdata&marketid=${pairId(pair)}';
    Client.getUrl(Uri.parse(uri)).then((request) 
        => request.close(), onError: (e) => c.completeError(e))
        .then((HttpClientResponse response) {
          response.transform(new Utf8Decoder()).transform(Api.JSON_DECODER)
            .listen((json) {
              if (1 == json['success']) {
              var result = json['return'];
              Map<String, CryptsyOrderData> data = <String, CryptsyOrderData> {};
              if (result is Map<String, Map<String, dynamic>>) {
                result.forEach((name, orders) {
                  data[name] = new CryptsyOrderData(orders);
                });
                c.complete(data);
              }
            } else {
              c.completeError('Request failed');
            }
          });
    }, onError: (e) => c.completeError(e));
    return c.future;
  }

  Future<Map<String, CryptsyMarketData>> generalMarketData ([Pair pair]) {
    Completer<Map<String, CryptsyMarketData>> c = 
        new Completer<Map<String, CryptsyMarketData>> ();
    String uri = null == pair ? '$publicUrl?method=marketdatav2' 
        : '$publicUrl?method=singlemarketdata&marketid=${pairId(pair)}';
    Client.getUrl(Uri.parse(uri)).then((request) 
        => request.close(), onError: (e) => c.completeError(e))
        .then((HttpClientResponse response) {
          response.transform(UTF8.decoder).transform(Api.JSON_DECODER)
          .listen((json) {
            if (1 == json['success']) {
              var result = json['return']['markets'];
              Map<String, CryptsyMarketData> markets = 
                  <String, CryptsyMarketData> {};
              if (result is Map<String, Map<String, dynamic>>) {
                result.forEach((name, market) {
                  markets[name] = new CryptsyMarketData(market);
                });
                c.complete(markets);
              }
            } else {
              c.completeError('Request failed');
            }
          });
    }, onError: (e) => c.completeError(e));
    return c.future;
  }
  
  String pairId (Pair pair) => CryptsyIds[pair];
  
  static final HttpClient Client = new HttpClient();
}