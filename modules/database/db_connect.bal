import ballerinax/mysql;
import ballerina/io;

configurable string dbHost = "localhost";
configurable int dbPort = 3306;
configurable string dbName = "my_bal";
configurable string dbUser = "root";
configurable string dbPassword = "Castroaterice2day";

public final mysql:Client dbClient = check new(
    host = dbHost,
    port = dbPort,
    database = dbName,
    user = dbUser,
    password = dbPassword
);

public function testConnection() returns error? {
    stream<record {}, error?> result = dbClient->query(`SELECT 1`);
    check result.close();
    io:println("Connection to MySQL database successful");
}