String _dbUrl = "";

set databaseUrl(String url) => _dbUrl = url;

String get databaseUrl => _dbUrl;

String get version => '1.2.0+4';

Map<String, String> get adminLogin => {
      'username': '<username>',
      'password': '<password>',
    };
