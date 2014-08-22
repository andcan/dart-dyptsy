part of dyptsy;

class KrakenAssetInfo {
  
  KrakenAssetInfo (Map<String, dynamic> data)
      : altName       = data['altname'],
      assetClass      = data['aclass'],
      decimals        = data['decimals'],
      displayDecimals = data['display_decimals'];
  
  final String altName;
  final String assetClass;
  final int decimals;
  final int displayDecimals;
  
  String toString () => '''{
  altname         : $altName,
  assetClass      : $assetClass,
  decimals        : $decimals,
  displayDecimals : $displayDecimals
}''';
}

class KrakenAssetPairFee {
  
  KrakenAssetPairFee(List<String> data)
      : amount    = num.parse(data[0]),
      feePercent  = num.parse(data[1]);
  
  final num amount;
  final num feePercent;
  
  String toString () => '''{
  amount: $amount,
  fee   : $feePercent%
}''';
}

class KrakenAssetPair {
  
  KrakenAssetPair (Map<String, dynamic> data)
      : altName         = data['altname'],
      assetClassBase    = data['aclass_base'],
      assetClassQuote   = data['aclass_quote'],
      base              = data['base'],
      fees              = (data['fees'] as List<List<String>>)
                            .map((data) => new KrakenAssetPairFee(data))
                            .toList(growable: false),
      feeVolumeCurrency = data['fee_volume_currency'],
      leverage          = data['leverage'],
      lot               = data['lot'],
      lotDecimals       = data['lot_decimals'],
      lotMultiplier     = data['lot_multiplier'],
      marginCall        = data['margin_call'],
      marginStop        = data['margin_stop'],
      quote             = data['quote'],
      pairDecimals      = data['pair_decimals'];
  
  final String altName;
  final String assetClassBase;
  final String assetClassQuote;
  final String base;
  final List<KrakenAssetPairFee> fees;
  final String feeVolumeCurrency;
  final List leverage;
  final String lot;
  final int lotDecimals;
  final int lotMultiplier;
  final int marginCall;
  final int marginStop;
  final String quote;
  final int pairDecimals;
  
  String toString () => '''{
  altName           : $altName,
  assetClassBase    : $assetClassBase,
  assetClassQuote   : $assetClassQuote,
  base              : $base,
  fees              : $fees,
  feeVolumeCurrency : $feeVolumeCurrency,
  leverage          : $leverage,
  lot               : $lot,
  lotDecimals       : $lotDecimals,
  lotMultiplier     : $lotMultiplier,
  marginCall        : $marginCall,
  marginStop        : $marginStop,
  quote             : $quote,
  pairDecimals      : $pairDecimals
}''';
}

class KrakenTicker {
  
  KrakenTicker (Map<String, dynamic> data)
      : ask           = new KrakenTickerData(data['a']),
      averagePrice    = new KrakenTickerVolume(data['p']),
      bid             = new KrakenTickerData(data['b']),
      high            = new KrakenTickerVolume(data['h']),
      lastTrade       = new KrakenTickerData(data['c']),
      low             = new KrakenTickerVolume(data['l']),
      numberOfTrades  = new KrakenTickerVolume.fromInt(data['t']),
      openingPrice    = num.parse(data['o']),
      volume          = new KrakenTickerVolume(data['v']);
  
  final KrakenTickerData ask;
  //Volume weigthed
  final KrakenTickerVolume averagePrice;
  final KrakenTickerData bid;
  final KrakenTickerVolume high;
  final KrakenTickerData lastTrade;
  final KrakenTickerVolume low;
  final KrakenTickerVolume numberOfTrades;
  //00:00:00 UTC
  final num openingPrice;
  final KrakenTickerVolume volume;
  
  String toString () => '''{
  ask             : $ask,
  averagePrice    : $averagePrice,
  bid             : $bid,
  high            : $high,
  lastTrade       : $lastTrade,
  low             : $low,
  numberOfTrades  : $numberOfTrades
}''';
}

class KrakenTickerData {
  
  KrakenTickerData(List<String> data)
      : amount  = num.parse(data[1]),
      price     = num.parse(data[0]);
  
  final num amount;
  final num price;
  
  String toString () => '''{
  amount  : $amount,
  price   : $price
}''';
}

class KrakenTickerVolume {
  
  KrakenTickerVolume(List<String> data)
      : last24h = num.parse(data[1]),
      today     = num.parse(data[0]);
  
  KrakenTickerVolume.fromInt (List<int> data)
      : last24h = data[1],
      today     = data[0];
  
  final num last24h;
  final num today;
  
  String toString () => '''{
  last24h : $last24h,
  today   : $today
}''';
}

class KrakenServerTime {
  
  KrakenServerTime (Map<String, dynamic> data)
      : rfc1123 = data['rfc1123'],
      unixTime  = data['unixtime'];
  
  final String rfc1123;
  final int unixTime;
  
  String toString () => '''{
  rfc1123   : $rfc1123,
  unixTime  : $unixTime
}''';
}