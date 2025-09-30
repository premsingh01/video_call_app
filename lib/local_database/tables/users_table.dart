class UsersTable {
  static const String tableName = "users";

  static const String createTable = """
    CREATE TABLE $tableName(
      id INTEGER,
      email TEXT,
      first_name TEXT,
      last_name TEXT,
      avatar TEXT
    )
  """;
}