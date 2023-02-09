import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Env? _instance;

  Env._();
  static Env get i {
    _instance ??= Env._();
    return _instance!;
  }

  // Load() por padrão já pega o .env
  Future<void> load() => dotenv.load();

  // Extrair o dado do .env
  String? operator [](String key) => dotenv.env[key];
}

// Precisa passar na raiz(main.dart) do projeto para carregar a key;
