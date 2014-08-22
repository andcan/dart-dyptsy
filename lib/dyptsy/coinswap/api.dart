part of dyptsy;

class CoinSwap extends Api {
  CoinSwap();
  
  String get publicUrl => 'https://api.coin-swap.net/market';
  List<Coin> get supportedCoins => CoinSwapCoins;
  List<Pair> get supportedPairs => CoinSwapPairs;
  
  String pairId (Pair p) => CoinSwapIds[p];
  
  Future<Map<String, SummaryData>> summary () {
    Completer c = new Completer<Map<String, SummaryData>> ();
    Client.getUrl(Uri.parse('$publicUrl/summary')).then((request) =>
        request.close()).then((response) {
      response.transform(UTF8.decoder).transform(Api.JSON_DECODER)
        .listen((List<Map<String, String>> data) {
        Map<String, SummaryData> summary = <String, SummaryData>{};
        data.forEach((d) {
          summary[d['id']] = new SummaryData(d);
        });
        c.complete(summary);
      }, onError: (e) => c.completeError(e));
    });
    return c.future;
  }
  
  static final HttpClient Client = new HttpClient();
}