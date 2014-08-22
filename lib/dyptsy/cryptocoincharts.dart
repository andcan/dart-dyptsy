part of dyptsy;
/*
class CryptoCoinCharts extends Api {
  
  CryptoCoinCharts() : super ('http://www.cryptocoincharts.info/v2/api');
  
  Future<List<CryptoCoinChartsCoin>> listCoins () {
    Completer<List<CryptoCoinChartsCoin>> c = 
        new Completer<List<CryptoCoinChartsCoin>>();
    Api.Client.getUrl(Uri.parse('$baseUrl/listCoins')).then((request) =>
        request.close(), onError: (e) => c.completeError(e)).then((response) {
      StringBuffer buffer = new StringBuffer ();
      response.transform(Api.UTF8_DECODER).listen((data) =>
          buffer.write(data), onDone: () {
            var json = Api.JSON_DECODER.convert(buffer.toString());
            if (json is! List<Map<String, String>>) {
              throw new Error();
            }
            for (int i = 0; i < json.length; ++i) {
              json[i] = new CryptoCoinChartsCoin(json[i]);
            }
            c.complete(json);
          }, onError: (e) => c.completeError(e));
    });
    return c.future;
  }
  
  Future<CryptoCoinChartsPair> pair (String id1, String id2) {
    Completer<CryptoCoinChartsPair> c = new Completer<CryptoCoinChartsPair>();
    Api.Client.getUrl(Uri.parse('$baseUrl/tradingPair/${id1}_$id2'))
      .then((request) => request.close(), onError: (e) => c.completeError(e))
      .then((response) {
        StringBuffer buffer = new StringBuffer ();
        response.transform(Api.UTF8_DECODER).listen((data) =>
            buffer.write(data), onDone: () {
            var json = Api.JSON_DECODER.convert(buffer.toString());
            if (json is! Map<String, String>) {
              throw new Error();
            }
            c.complete(new CryptoCoinChartsPair(json));
          }, onError: (e) => c.completeError(e));
    });
    return c.future;
  }
}

class CryptoCoinChartsResponse {
  CryptoCoinChartsResponse(Map<String, dynamic> json) : super(json);
}

class CryptoCoinChartsCoin extends CryptoCoinChartsResponse {
  CryptoCoinChartsCoin(Map<String, dynamic> json) : super(json);
  
  String get id => json['id'];
  
  String get name => json['name'];
  
  String get priceBtc => json['price_btc'];
  
  String get volumeBtc => json['volume_btc'];
  
  String get website => json['website'];
  
  String toString () => json.toString();
}

class CryptoCoinChartsPair extends CryptoCoinChartsResponse {
  CryptoCoinChartsPair(Map<String, dynamic> json) : super(json);
  
  String get bestMarket => json['best_market'];
  
  String get id => json['id'];
  
  String get latestTrade => json['latest_trade'];
  
  String get price => json['price'];
  
  String get priceBefore24h => json['price_before_24h'];
  
  String get volumeBtc => json['volume_btc'];
  
  String get volumeFirst => json['volume_first'];
  
  String get volumeSecond => json['volume_second'];
  
  String toString () => json.toString();
}*/