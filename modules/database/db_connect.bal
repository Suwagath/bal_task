import ballerinax/mysql;
import ballerina/io;

# Database configuration using configurable variables
# These values can be overridden in Config.toml
# Required values (dbUser and dbPassword) must be provided in Config.toml

# Host address of the MySQL server
configurable string dbHost = "localhost";

# Port number of the MySQL server
configurable int dbPort = 3306;

# Name of the database to connect to
configurable string dbName = "my_bal";

# MySQL username (required)
configurable string dbUser = ?;

# MySQL password (required)
configurable string dbPassword = ?;

# Global database client instance
# This is initialized when the module is loaded and used across all database operations
public final mysql:Client dbClient = check new(
    host = dbHost,
    port = dbPort,
    database = dbName,
    user = dbUser,
    password = dbPassword
);

# Tests the database connection by executing a simple query
# + return - Error if the connection test fails
public function testConnection() returns error? {
    stream<record {}, error?> result = dbClient->query(`SELECT 1`);
    check result.close();
    io:println("Connection to MySQL database successful");
}