import 'coin.dart';
import 'package:orm/orm.dart';

class Order extends Entity {
  int _id;
  Coin _first;
  double _price;
  Coin _second;
  double _total;
  
  Order ({int id, Coin first, double price, Coin second, double total})
  : this._id = id,
    this._first = first,
    this._price = price,
    this._second = second,
    this._total = total;

  Order.fromMap (Map<String, dynamic> values)
  : this._id = values['id'],
    this._first = values['first'],
    this._price = values['price'],
    this._second = values['second'],
    this._total = values['total'];

  Order.fromMapSym (Map<Symbol, dynamic> values)
  : this._id = values[OrderMeta.SYMBOL_ID],
  this._first = values[OrderMeta.SYMBOL_FIRST],
  this._price = values[OrderMeta.SYMBOL_PRICE],
  this._second = values[OrderMeta.SYMBOL_SECOND],
  this._total = values[OrderMeta.SYMBOL_TOTAL];
  
  int get id => _id;
  Coin get first => _first;
  double get price => _price;
  Coin get second => _second;
  double get total => _total;
  OrderMeta get entityMetadata => _meta;

  int get hashCode {
    int hash = 1;
    hash = 31 * hash + id.hashCode;
    hash = 31 * hash + first.hashCode;
    hash = 31 * hash + price.hashCode;
    hash = 31 * hash + second.hashCode;
    hash = 31 * hash + total.hashCode;
    return hash;
  }
  
  bool operator == (Order order) => id == order.id &&
    first == order.first &&
    price == order.price &&
    second == order.second &&
    total == order.total;
  
  set id (int id) {
    if (OrderMeta.PERSISTABLE_ID.validate(id)) {
      _id = id;
      if (entityMetadata.syncEnabled(this)) {
        _meta.onChange(this, OrderMeta.FIELD_ID);
      }
    } else {
      throw new ArgumentError ('id is not valid');
    }
  }
  set first (Coin first) {
    if (OrderMeta.PERSISTABLE_FIRST.validate(first)) {
      _first = first;
      if (entityMetadata.syncEnabled(this)) {
        _meta.onChange(this, OrderMeta.FIELD_FIRST);
      }
    } else {
      throw new ArgumentError ('first is not valid');
    }
  }
  set price (double price) {
    if (OrderMeta.PERSISTABLE_PRICE.validate(price)) {
      _price = price;
      if (entityMetadata.syncEnabled(this)) {
        _meta.onChange(this, OrderMeta.FIELD_PRICE);
      }
    } else {
      throw new ArgumentError ('price is not valid');
    }
  }
  set second (Coin second) {
    if (OrderMeta.PERSISTABLE_SECOND.validate(second)) {
      _second = second;
      if (entityMetadata.syncEnabled(this)) {
        _meta.onChange(this, OrderMeta.FIELD_SECOND);
      }
    } else {
      throw new ArgumentError ('second is not valid');
    }
  }
  set total (double total) {
    if (OrderMeta.PERSISTABLE_TOTAL.validate(total)) {
      _total = total;
      if (entityMetadata.syncEnabled(this)) {
        _meta.onChange(this, OrderMeta.FIELD_TOTAL);
      }
    } else {
      throw new ArgumentError ('total is not valid');
    }
  }
  
  String toString () => '''{
    id: $id,
    first: $first,
    price: $price,
    second: $second,
    total: $total
  }''';
  
  static final OrderMeta _meta = new OrderMeta();
}

class OrderMeta extends EntityMeta<Order> {

  String get idName => 'id';

  Symbol get idNameSym => SYMBOL_ID;

  String get entityName => ENTITY_NAME;

  Symbol get entityNameSym => ENTITY_NAME_SYM;

  List<String> get fields => FIELDS;

  List<Symbol> get fieldsSym => FIELDS_SYM;

  List asList (Order order) => [
    order.id,
    order.first,
    order.price,
    order.second,
    order.total
  ];

  Map<String, dynamic> asMap (Order order) => <String, dynamic> {
    'id': order.id,
    'first': order.first,
    'price': order.price,
    'second': order.second,
    'total': order.total
  };
  
  Map<Symbol, dynamic> asMapSym (Order order) => <Symbol, dynamic> {
    SYMBOL_ID: order.id,
    SYMBOL_FIRST: order.first,
    SYMBOL_PRICE: order.price,
    SYMBOL_SECOND: order.second,
    SYMBOL_TOTAL: order.total
  };
  
  String delete (Order order) => "DELETE FROM Order WHERE Order.$idName = '${get(order, idName)}';";
  
  dynamic get (Order order, String field) {
    switch (field) {
      case 'id':
        return order.id;
      case 'first':
        return order.first;
      case 'price':
        return order.price;
      case 'second':
        return order.second;
      case 'total':
        return order.total;
      default:
        throw new ArgumentError('Invalid field $field');
    }
  }
  
  String insert (Order order, {bool ignore: false}) {    
    var id = order.id;
    if (id is Entity) {
      id = id.entityMetadata.get(id, id.entityMetadata.idName);
    }    
    var first = order.first;
    if (first is Entity) {
      first = first.entityMetadata.get(first, first.entityMetadata.idName);
    }    
    var price = order.price;
    if (price is Entity) {
      price = price.entityMetadata.get(price, price.entityMetadata.idName);
    }    
    var second = order.second;
    if (second is Entity) {
      second = second.entityMetadata.get(second, second.entityMetadata.idName);
    }    
    var total = order.total;
    if (total is Entity) {
      total = total.entityMetadata.get(total, total.entityMetadata.idName);
    }
    return "INSERT${ignore ? 'ignore ' : ' '}INTO Order (id, first, price, second, total) VALUES (${id is num ? '${id}' : "'${id}'"}, ${first is num ? '${first}' : "'${first}'"}, ${price is num ? '${price}' : "'${price}'"}, ${second is num ? '${second}' : "'${second}'"}, ${total is num ? '${total}' : "'${total}'"});";
  }
  
  String select (Order order, [List<String> fields]) {
    if (null == fields) {
      return 'SELECT * FROM Order WHERE Order.id = ${order.id} LIMIT 1';
    } else if (fields.isEmpty) {
      throw new ArgumentError('fields cannot be empty');
    }
    StringBuffer query = new StringBuffer('SELECT ');
    fields.forEach((field) => query.write('$field, '));
    return "${query.toString().substring(0, query.length - 2)} FROM Order WHERE Order.id = ${order.id} LIMIT 1;";
  }
  
  String selectAll (List<Order> orders, [List<String> fields]) {
    if (null == fields) {
      StringBuffer query = new StringBuffer('SELECT * FROM Order WHERE Order.id IN (');
      orders.forEach((order) => query.write("'${order.id}', "));
      return '${query.toString().substring(0, query.length - 2)}) LIMIT ${orders.length}';
    } else if (fields.isEmpty) {
      throw new ArgumentError('fields cannot be empty');
    }
    StringBuffer query = new StringBuffer('SELECT ');
    fields.forEach((field) => query.write('$field, '));
    query = new StringBuffer('${query.toString().substring(0, query.length - 2)} FROM Order WHERE Order.id IN (');
    orders.forEach((order) => query.write("${order.id is num ? order.id : "'${order.id}'"}, "));
    return '${query.toString().substring(0, query.length - 2)}) LIMIT ${orders.length};';
  }
  
  void set (Order order, String field, value) {
    switch (field) {
      case 'id':
        order.id = value;
        break;
      case 'first':
        order.first = value;
        break;
      case 'price':
        order.price = value;
        break;
      case 'second':
        order.second = value;
        break;
      case 'total':
        order.total = value;
        break;
      default:
        throw new ArgumentError('Invalid field $field');
    }
  }
  
  String update (Order order, List values, [List<String> fields]) {
    if (null == fields) {
      fields = OrderMeta.FIELDS;
    }
    if (fields.isEmpty) {
      throw new ArgumentError('fields cannot be empty');
    }
    StringBuffer query = new StringBuffer('UPDATE Order SET ');
    fields.forEach((f) {
      var value = get(order, f);
      if (value is Entity) {
        value = value.entityMetadata.get(value, value.entityMetadata.idName);
      }
      query.write('$f = ${value is num ? value : "'$value'"}, ');
    });
    var id = get(order, idName);
    return "${query.toString().substring(0, query.length - 2)} WHERE Order.$idName = ${id is num ? id : "'$id'"};";
  }
  
  static const String ENTITY_NAME = 'Order';
  static const Symbol ENTITY_NAME_SYM = const Symbol ('Order');
  static const String FIELD_ID = 'id',
    FIELD_FIRST = 'first',
    FIELD_PRICE = 'price',
    FIELD_SECOND = 'second',
    FIELD_TOTAL = 'total';
  static const List<String> FIELDS = const <String>[
    FIELD_ID,
    FIELD_FIRST,
    FIELD_PRICE,
    FIELD_SECOND,
    FIELD_TOTAL
  ];
  static const List<Symbol> FIELDS_SYM = const <Symbol>[
    SYMBOL_ID,
    SYMBOL_FIRST,
    SYMBOL_PRICE,
    SYMBOL_SECOND,
    SYMBOL_TOTAL
  ];
  static const String SQL_CREATE = 'CREATE TABLE Order (id INT NOT NULL, first VARCHAR(5) NOT NULL, price DOUBLE NOT NULL, second VARCHAR(5) NOT NULL, total DOUBLE NOT NULL, PRIMARY KEY(id));';
  static const Persistable PERSISTABLE_ID = const IntPersistable (),
    PERSISTABLE_FIRST = const Persistable (),
    PERSISTABLE_PRICE = const Persistable (),
    PERSISTABLE_SECOND = const Persistable (),
    PERSISTABLE_TOTAL = const Persistable ();
  static const Symbol SYMBOL_ID = const Symbol('id'),
    SYMBOL_FIRST = const Symbol('first'),
    SYMBOL_PRICE = const Symbol('price'),
    SYMBOL_SECOND = const Symbol('second'),
    SYMBOL_TOTAL = const Symbol('total');
}
