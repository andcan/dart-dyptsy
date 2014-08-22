part of dyptsy;

class SummaryData {
  
  SummaryData (Map<String, String> data)
      : this.ask = num.parse(data['ask']),
      this.bid = num.parse(data['bid']),
      this.dayHigh = num.parse(data['dayhigh']),
      this.dayLow = num.parse(data['daylow']),
      this.dayVolume = num.parse(data['dayvolume']),
      this.exchange = data['exchange'],
      this.id = data['id'],
      this.lastPrice = num.parse(data['lastprice']),
      this.openOrders = int.parse(data['openorders']),
      this.symbol = data['symbol'];
  
  final num ask;
  final num bid;
  final num dayHigh;
  final num dayLow;
  final num dayVolume;
  final String exchange;
  final String id;
  final num lastPrice;
  final int openOrders;
  final String symbol;
}