
String? _dbUrl;

set databaseUrl(String value) => _dbUrl = value;

String get databaseUrl => _dbUrl ?? "";

String get version => '1.1';

Map<String, String> get adminLogin => {'username': '<username>', 'password': '<password>'};

