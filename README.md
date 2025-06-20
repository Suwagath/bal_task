# User Management Service

A simple user management service built with Ballerina.

## Configuration

This service requires a MySQL database connection. To configure the database connection:

1. Copy `Config.sample.toml` to `Config.toml`:
   ```bash
   cp Config.sample.toml Config.toml
   ```

2. Edit `Config.toml` and update the database credentials:
   ```toml
   [bal_task.database]
   dbHost = "localhost"
   dbPort = 3306
   dbName = "my_bal"
   dbUser = "your_username"
   dbPassword = "your_password"
   ```

Note: `Config.toml` is ignored by git to keep credentials secure. Never commit your actual database credentials to version control.

## Running the Service

To run the service:
```bash
bal run
```

## Running Tests

To run the tests:
```bash
BAL_TEST_MODE=true bal test
``` 