// import 'package:jabber/models/cards.dart';

// class CardDatabase {
//   static final CardDatabase instance = CardDatabase._init();

//   static Database _database;
//   CardDatabase._init();

//   final getInstance = instance.database;

// //Create a getter to obviously get our database
// //and also check to see if the database exist or not...
//   Future<DataBase> get database async {
//     if (_database != null) return _database;

//     _database = await _initDB('savedCardsfile.db');
//     return _database;
//   }

//   //This method creates database if our database does not exist
//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasePath();
//     final path = join(dbPath, filePath);
//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   //This method classs the on create callback that the openDatabase creates
//   Future _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE $tableName (
//       ${CardFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
//       ${CardFields.cardHolder} TEXT NOT NULL,
//       ${CardFields.expYear} INTEGER NOT NULL,
//       ${CardFields.cardHolder} INTEGER NOT NULL,
//       ${CardFields.cvs} INTEGER NOT NULL,
//       )
//       ''');
//   }

//   //Following method are for crud functions with our database
//   Future<Cards> create(Cards cards) async {
//     final db = await getInstance;
//     final id = await db.insert(tableName, cards.toJson());
//     return cards.copy(id: id);
//   }

//   //this method reads only a single card
//   Future<Cards> readCard(int id) async {
//     final db = await getInstance;

//     final maps = await db.query(tableName,
//         columns: CardFields.values,
//         where: ' ${CardFields.id} = ?',
//         whereArgs: [id]);

//     if (maps.isNotEmpty) {
//       return Cards.fromJson(maps.first);
//     } else {
//       throw Exception('ID $id not found');
//     }
//   }

// //This method reads from all cards
//   Future<List<Cards>> readAllCards() async {
//     final db = await getInstance;
//     final results = await db.query(tableName);

//     return results.map((json) => Cards.fromJson(json)).toList();
//   }

// //This method updates the card with a specific id
//   Future<int> update(Cards card) async {
//     final db = await getInstance;
//     return await db.update(tableName, card.toJson(),
//         where: '${CardFields.id} = ?', whereArgs: [card.id]);
//   }

//   Future<int> delete(int id) async {
//     final db = await getInstance;
//     return await db
//         .delete(tableName, where: '${CardFields.id} = ?', whereArgs: [id]);
//   }

//   Future close() async {
//     final db = await getInstance;
//     db.close();
//   }
// }
