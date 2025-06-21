# User Management Service

A RESTful user management service built with Ballerina. This service provides CRUD operations for managing users with MySQL database integration.

> **Code Analysis Documentation**: Discusses an old code segment implementation and how it fails in terms of Ballerina's best coding practices. [Google Doc](https://docs.google.com/document/d/1sH_zae6Q5zrXgsVcPYiaxx0gws9pCsRqlh2fiTur-44/edit?usp=sharing).

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
- [Running the Service](#running-the-service)
- [Running Tests](#running-tests)
- [API Documentation](#api-documentation)
- [Data Models](#data-models)
- [Error Handling](#error-handling)
- [Development](#development)

## Prerequisites

- Ballerina Swan Lake 2023R1 or later
- MySQL 8.0 or later
- Git (for version control)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Suwagath/bal_task.git
   cd bal_task
   ```

2. Install dependencies:
   ```bash
   bal build
   ```

## Configuration

1. Copy the sample configuration file:
   ```bash
   cp Config.sample.toml Config.toml
   ```

2. Edit `Config.toml` with your database credentials:
   ```toml
   [bal_task.database]
   dbHost = "localhost"
   dbPort = 3306
   dbName = "my_bal"
   dbUser = "your_username"
   dbPassword = "your_password"
   ```

Note: `Config.toml` is ignored by git to keep credentials secure.

## Database Setup

1. Ensure MySQL server is running

2. Execute the database setup script:
   ```bash
   mysql -u your_username -p < resources/database/database.sql
   ```

   This will:
   - Create the `users` table
   - Insert sample test data

Database Schema:
```sql
CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    age INT
)
```

## Running the Service

1. Start the service:
   ```bash
   bal run
   ```

2. The service will start on port 8080 by default
   - You can change the port in `Config.toml` by setting `serverPort`

## Running Tests

Run the test suite:
```bash
BAL_TEST_MODE=true bal test
```

The tests will:
- Run on port 8081 (separate from main service)
- Execute all CRUD operation tests
- Verify data consistency
- Clean up test data

## API Documentation

### Endpoints

#### 1. Create User
- **Method**: POST
- **Path**: `/users/add`
- **Body**:
  ```json
  {
    "username": "johndoe",
    "email": "john@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "age": 30
  }
  ```
- **Response**:
  ```json
  {
    "message": "User added successfully."
  }
  ```

#### 2. Get User by ID
- **Method**: GET
- **Path**: `/users/id/{userId}`
- **Response**:
  ```json
  {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "age": 30
  }
  ```

#### 3. Search Users
- **Method**: GET
- **Path**: `/users/search?username={pattern}`
- **Response**:
  ```json
  [
    {
      "id": 1,
      "username": "johndoe",
      "email": "john@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "age": 30
    }
  ]
  ```

#### 4. Get All Users
- **Method**: GET
- **Path**: `/users`
- **Response**: Array of user objects

#### 5. Update User
- **Method**: PUT
- **Path**: `/users`
- **Body**:
  ```json
  {
    "id": 1,
    "username": "johndoe",
    "email": "john.updated@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "age": 31
  }
  ```
- **Response**:
  ```json
  {
    "message": "User updated successfully."
  }
  ```

#### 6. Delete User
- **Method**: DELETE
- **Path**: `/users/id/{userId}`
- **Response**:
  ```json
  {
    "message": "User deleted successfully."
  }
  ```

## Data Models

### User
```ballerina
type User record {
    int id;
    string username;    // Unique
    string email;       // Unique
    string firstName;
    string lastName;
    int? age;          // Optional
};
```

### UserInput
```ballerina
type UserInput record {
    string username;
    string email;
    string firstName;
    string lastName;
    int? age;
};
```

## Error Handling

The service returns appropriate HTTP status codes:
- 200: Successful operation
- 400: Bad request (invalid input)
- 404: Resource not found
- 500: Internal server error

Error responses include a message:
```json
{
    "message": "Error description"
}
```

## Development

### Project Structure
```
bal_task/
├── Ballerina.toml         # Project configuration
├── Config.toml            # Environment configuration
├── main.bal              # Service implementation
├── modules/
│   └── database/         # Database operations
│       ├── db_connect.bal
│       ├── db_functions.bal
│       ├── db_queries.bal
│       └── types.bal
├── resources/
│   └── database/
│       └── database.sql  # Database schema
└── tests/
    └── service_test.bal  # Integration tests
```

### Adding New Features

1. Update the database schema if needed
2. Add new types in `types.bal`
3. Implement database functions in `db_functions.bal`
4. Add new endpoints in `main.bal`
5. Write tests in `service_test.bal`

### Best Practices

1. Always validate input data
2. Use proper error handling
3. Write tests for new features
4. Keep documentation updated
5. Follow Ballerina coding conventions

### Common Issues

1. Database Connection:
   - Ensure MySQL is running
   - Verify credentials in Config.toml
   - Check port availability

2. Port Conflicts:
   - Service port (8080) or test port (8081) might be in use
   - Change ports in configuration if needed

3. Build Issues:
   - Run `bal build --clean` to clean build
   - Verify Ballerina version compatibility 
