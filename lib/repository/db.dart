import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Conexao {
  Conexao._();

  static const _dbname = "supreagro.db";

  String get _sqlScript => '''
    CREATE TABLE pedido (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      cliente INTEGER,
      usuario INTEGER,
      empresa INTEGER,
      formaPagamento INTEGER,
      dataPedido TEXT,
      dataEntrega TEXT,
      observacao TEXT,
      dataPagamento TEXT,
      cpfClienteNovo TEXT,
      nomeClienteNovo TEXT,
      enderecoClienteNovo TEXT,
      numeroClienteNovo TEXT,
      sincronizado INTEGER DEFAULT 0,
      saidaStatus INTEGER DEFAULT 0
    );
  ''';
// falta os itens do pedido.

  //singleton
  Conexao._privateConstructor();
  static final Conexao instance = Conexao._privateConstructor();
  // tem somente uma referência ao banco de dados - com safenull
  static Database? _database;

  Future<Database> get database async {
    return _database ??= await initDB();
  }

  Future<Database> initDB() async {
    // instancia o db na primeira vez que for acessado
    return openDatabase(
      join(await getDatabasesPath(), _dbname),
      onCreate: (db, version) {
        return db.execute(_sqlScript);
      },
      version: 1,
    );
  }
}
