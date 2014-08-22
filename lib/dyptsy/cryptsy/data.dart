part of dyptsy;

class CryptsyMarketData extends CryptsyOrderData {
  CryptsyMarketData(Map<String, dynamic> data)
      : lastTradePrice = null == data['lasttradeprice'] ? null 
          : num.parse(data['lasttradeprice']),
      lastTradeTime   = data['lasttradetime'],
      recentTrades    = null == data['recenttrades'] ? <CryptsyTrade>[]
                        : (data['recenttrades'] as List<Map<String, String>>)
                          .map((f) => new CryptsyTrade(f))
                          .toList(growable: false),
      volume          = num.parse(data['volume']), super(data);
  
  final num lastTradePrice;
  final String lastTradeTime;
  final List<CryptsyTrade> recentTrades;
  final num volume;
  
  String toString () => '''{
  buyOrders       : $buyOrders,
  label           : $label,
  lastTradePrice  : $lastTradePrice,
  lastTradeTime   : $lastTradeTime,
  marketId        : $marketId,
  primaryCode     : $primaryCode,
  primaryName     : $primaryName,
  recentTrades    : $recentTrades,
  secondaryCode   : $secondaryCode,
  secondaryName   : $secondaryCode,
  sellOrders      : $sellOrders,
  volume          : $volume
}''';
}

class CryptsyOrder {
  CryptsyOrder(Map<String, String> data)
      : price   = num.parse(data['price']),
      quantity  = num.parse(data['quantity']),
      total     = num.parse(data['total']);
  
  final num price;
  final num quantity;
  final num total;
  
  String toString () => '''{
  price     : $price,
  quantity  : $quantity,
  total     : $total
}''';
}

class CryptsyOrderData {
  CryptsyOrderData(Map<String, dynamic> data)
      : buyOrders     = null == data['buyorders'] ? <CryptsyOrder>[]
                        : (data['buyorders'] as List<Map<String, String>>)
                          .map((f) => new CryptsyOrder(f))
                          .toList(growable: false),
      label           = data['label'],
      marketId        = data['marketid'],
      primaryCode     = data['primarycode'],
      primaryName     = data['primaryname'],
      secondaryCode   = data['secondarycode'],
      secondaryName   = data['secondaryname'],
      sellOrders      = null == data['sellorders'] ? <CryptsyOrder> []
                        : (data['sellorders'] as List<Map<String, String>>)
                          .map((f) => new CryptsyOrder(f))
                          .toList(growable: false);
  
  final List<CryptsyOrder> buyOrders;
  final String label;
  final String marketId;
  final String primaryCode;
  final String primaryName;
  final String secondaryCode;
  final String secondaryName;
  final List<CryptsyOrder> sellOrders;
  
  String toString () => '''{
  buyOrders       : $buyOrders,
  label           : $label,
  marketId        : $marketId,
  primaryCode     : $primaryCode,
  primaryName     : $primaryName,
  secondaryCode   : $secondaryCode,
  secondaryName   : $secondaryCode,
  sellOrders      : $sellOrders,
}''';
}

class CryptsyTrade {
  CryptsyTrade(Map<String, String> data)
      : id      = data['id'],
      price     = num.parse(data['price']),
      quantity  = num.parse(data['quantity']),
      time      = data['time'],
      total     = num.parse(data['total']);
  
  final String id;
  final num price;
  final num quantity;
  final String time;
  final num total;
  
  String toString () => '''{
  id        : $id,
  price     : $price,
  quantity  : $quantity,
  time      : $time,
  total     : $total
}''';
}