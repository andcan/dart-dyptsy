import 'package:orm/orm.dart';

class Coin {
  @Persistable(length: 25) String name;
  @Id(max: 5) String shortName;
}