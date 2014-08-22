part of dyptsy;

class PoloniexTicker {
  
  PoloniexTicker (Map<String, String> data)
      : this.baseVolume     = num.parse(data['baseVolume']),
        this.highestBid     = num.parse(data['highestBid']),
        this.last           = num.parse(data['last']),
        this.lowestAsk      = num.parse(data['lowestAsk']),
        this.percentChange  = num.parse(data['percentChange']),
        this.quoteVolume    = num.parse(data['quoteVolume']);
  
  final num baseVolume;
  final num highestBid;
  final num last;
  final num lowestAsk;
  final num percentChange;
  final num quoteVolume;
}

class PoloniexVolume {
  PoloniexVolume (Coin this.coin, num this.volume);
  
  final Coin coin;
  final num volume;
}