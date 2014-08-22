part of dyptsy;

abstract class Api {
  Api();
  
  String get publicUrl;
  List<Coin> get supportedCoins;
  List<Pair> get supportedPairs;
  
  String pairId (Pair pair);
  
  static final HttpClient Client = new HttpClient ();
  
  static const JsonDecoder JSON_DECODER = const JsonDecoder();
}

abstract class MarketData {
  
  MarketData ({num this.ask, num this.bid, Coin this.first, Coin this.second,
    String this.id, num this.volumeBtc});
  
  /**
   * Lowest ask.
   */
  final num ask;
  /**
   * Highest bid.
   */
  final num bid;
  final Coin first;
  /**
   * Id of this market.
   */
  final String id;
  final Coin second;
  /**
   * Traded volume ([BitCoin])
   */
  final num volumeBtc;
}





