import 'coin.dart';
import 'package:orm/orm.dart';

class Order {
  @Id() int id;
  @Persistable() Coin first;
  @Persistable() double price;
  @Persistable() Coin second;
  @Persistable() double total;
}