import 'package:orm/orm.dart';

class Coin extends Entity {
  String _name;
  String _shortName;
  
  Coin ({String name, String shortName})
  : this._name = name,
    this._shortName = shortName;

  Coin.fromMap (Map<String, dynamic> values)
  : this._name = values['name'],
    this._shortName = values['shortName'];

  Coin.fromMapSym (Map<Symbol, dynamic> values)
  : this._name = values[CoinMeta.SYMBOL_NAME],
  this._shortName = values[CoinMeta.SYMBOL_SHORTNAME];
  
  String get name => _name;
  String get shortName => _shortName;
  CoinMeta get entityMetadata => _meta;

  int get hashCode {
    int hash = 1;
    hash = 31 * hash + name.hashCode;
    hash = 31 * hash + shortName.hashCode;
    return hash;
  }
  
  bool operator == (Coin coin) => name == coin.name &&
    shortName == coin.shortName;
  
  set name (String name) {
    if (CoinMeta.PERSISTABLE_NAME.validate(name)) {
      _name = name;
      if (entityMetadata.syncEnabled(this)) {
        _meta.onChange(this, CoinMeta.FIELD_NAME);
      }
    } else {
      throw new ArgumentError ('name is not valid');
    }
  }
  set shortName (String shortName) {
    if (CoinMeta.PERSISTABLE_SHORTNAME.validate(shortName)) {
      _shortName = shortName;
      if (entityMetadata.syncEnabled(this)) {
        _meta.onChange(this, CoinMeta.FIELD_SHORTNAME);
      }
    } else {
      throw new ArgumentError ('shortName is not valid');
    }
  }
  
  String toString () => '''{
    name: $name,
    shortName: $shortName
  }''';
  
  static final CoinMeta _meta = new CoinMeta();
}

class CoinMeta extends EntityMeta<Coin> {

  String get idName => 'shortName';

  Symbol get idNameSym => SYMBOL_SHORTNAME;

  String get entityName => ENTITY_NAME;

  Symbol get entityNameSym => ENTITY_NAME_SYM;

  List<String> get fields => FIELDS;

  List<Symbol> get fieldsSym => FIELDS_SYM;

  List asList (Coin coin) => [
    coin.name,
    coin.shortName
  ];

  Map<String, dynamic> asMap (Coin coin) => <String, dynamic> {
    'name': coin.name,
    'shortName': coin.shortName
  };
  
  Map<Symbol, dynamic> asMapSym (Coin coin) => <Symbol, dynamic> {
    SYMBOL_NAME: coin.name,
    SYMBOL_SHORTNAME: coin.shortName
  };
  
  String delete (Coin coin) => "DELETE FROM Coin WHERE Coin.$idName = '${get(coin, idName)}';";
  
  dynamic get (Coin coin, String field) {
    switch (field) {
      case 'name':
        return coin.name;
      case 'shortName':
        return coin.shortName;
      default:
        throw new ArgumentError('Invalid field $field');
    }
  }
  
  String insert (Coin coin, {bool ignore: false}) {    
    var name = coin.name;
    if (name is Entity) {
      name = name.entityMetadata.get(name, name.entityMetadata.idName);
    }    
    var shortName = coin.shortName;
    if (shortName is Entity) {
      shortName = shortName.entityMetadata.get(shortName, shortName.entityMetadata.idName);
    }
    return "INSERT${ignore ? 'ignore ' : ' '}INTO Coin (name, shortName) VALUES (${name is num ? '${name}' : "'${name}'"}, ${shortName is num ? '${shortName}' : "'${shortName}'"});";
  }
  
  String select (Coin coin, [List<String> fields]) {
    if (null == fields) {
      return 'SELECT * FROM Coin WHERE Coin.shortName = ${coin.shortName} LIMIT 1';
    } else if (fields.isEmpty) {
      throw new ArgumentError('fields cannot be empty');
    }
    StringBuffer query = new StringBuffer('SELECT ');
    fields.forEach((field) => query.write('$field, '));
    return "${query.toString().substring(0, query.length - 2)} FROM Coin WHERE Coin.shortName = '${coin.shortName}' LIMIT 1;";
  }
  
  String selectAll (List<Coin> coins, [List<String> fields]) {
    if (null == fields) {
      StringBuffer query = new StringBuffer('SELECT * FROM Coin WHERE Coin.shortName IN (');
      coins.forEach((coin) => query.write("'${coin.shortName}', "));
      return '${query.toString().substring(0, query.length - 2)}) LIMIT ${coins.length}';
    } else if (fields.isEmpty) {
      throw new ArgumentError('fields cannot be empty');
    }
    StringBuffer query = new StringBuffer('SELECT ');
    fields.forEach((field) => query.write('$field, '));
    query = new StringBuffer('${query.toString().substring(0, query.length - 2)} FROM Coin WHERE Coin.shortName IN (');
    coins.forEach((coin) => query.write("'${coin.shortName}', "));
    return '${query.toString().substring(0, query.length - 2)}) LIMIT ${coins.length};';
  }
  
  void set (Coin coin, String field, value) {
    switch (field) {
      case 'name':
        coin.name = value;
        break;
      case 'shortName':
        coin.shortName = value;
        break;
      default:
        throw new ArgumentError('Invalid field $field');
    }
  }
  
  String update (Coin coin, List values, [List<String> fields]) {
    if (null == fields) {
      fields = CoinMeta.FIELDS;
    }
    if (fields.isEmpty) {
      throw new ArgumentError('fields cannot be empty');
    }
    StringBuffer query = new StringBuffer('UPDATE Coin SET ');
    fields.forEach((f) {
      var value = get(coin, f);
      if (value is Entity) {
        value = value.entityMetadata.get(value, value.entityMetadata.idName);
      }
      query.write('$f = ${value is num ? value : "'$value'"}, ');
    });
    var id = get(coin, idName);
    return "${query.toString().substring(0, query.length - 2)} WHERE Coin.$idName = ${id is num ? id : "'$id'"};";
  }
  
  static const String ENTITY_NAME = 'Coin';
  static const Symbol ENTITY_NAME_SYM = const Symbol ('Coin');
  static const String FIELD_NAME = 'name',
    FIELD_SHORTNAME = 'shortName';
  static const List<String> FIELDS = const <String>[
    FIELD_NAME,
    FIELD_SHORTNAME
  ];
  static const List<Symbol> FIELDS_SYM = const <Symbol>[
    SYMBOL_NAME,
    SYMBOL_SHORTNAME
  ];
  static const String SQL_CREATE = 'CREATE TABLE Coin (name VARCHAR(25) NOT NULL, shortName VARCHAR(5) NOT NULL, PRIMARY KEY(shortName));';
  static const Persistable PERSISTABLE_NAME = const StringPersistable (length: 25),
    PERSISTABLE_SHORTNAME = const StringPersistable (max: 5);
  static const Symbol SYMBOL_NAME = const Symbol('name'),
    SYMBOL_SHORTNAME = const Symbol('shortName');
}
