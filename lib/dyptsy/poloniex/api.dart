part of dyptsy;

class Poloniex extends Api {
  
  Poloniex ();
  
  String get publicUrl => 'https://poloniex.com/public';
  List<Coin> get supportedCoins => PoloniexCoins;
  List<Pair> get supportedPairs => PoloniexPairs;
  
  String pairId (Pair pair) => '${pair.second.shortName}_${pair.first
    .shortName}';
  
  Future<Map<String, PoloniexTicker>> returnTicker () {
    Completer<Map<String, PoloniexTicker>> c = 
        new Completer<Map<String, PoloniexTicker>> ();
    Api.Client.getUrl(Uri.parse('$publicUrl?command=returnTicker')).then((request) 
        => request.close(), onError: (e) => c.completeError(e))
        .then((HttpClientResponse response) {
          response.transform(UTF8.decoder).transform(Api.JSON_DECODER)
            .listen((json) {
              Map<String, PoloniexTicker> tickers = <String, PoloniexTicker>{};
              if (json is Map<String, Map<String, String>>) {
                json.forEach((name, ticker) {
                  tickers[name] = new PoloniexTicker(ticker);
                });
                c.complete(tickers);
              }
            });
    }, onError: (e) => c.completeError(e));
    return c.future;
  }
  
  /*Future<Map<String, Map<String, PoloniexVolume>>> return24hVolume () {
      Completer<Map<String, Map<Coin, num>>> c = 
          new Completer<Map<String, Map<Coin, num>>> ();
      Client.getUrl(Uri.parse('$publicUrl?command=return24hVolume'))
        .then((request) 
          => request.close(), onError: (e) => c.completeError(e))
          .then((HttpClientResponse response) {
            response.transform(UTF8.decoder).transform(Api.JSON_DECODER)
              .listen((json) {
                Map<String, Map<Coin, num>> volumes = <String, Map<Coin, num>>{};
                if (json is Map<String, Map<String, String>>) {
                  json.forEach((name, volume) {
                    volumes[name] = 
                  });
                  c.complete(volumes);
                }
              });
      }, onError: (e) => c.completeError(e));
      return c.future;
    }*/
}