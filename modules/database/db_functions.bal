import ballerina/io;

# Adds a new user to the database
# + user - The user input data containing username, email, names, and age
# + return - Error if the insertion fails
public function addUser(UserInput user) returns error? {
    _ = check dbClient->execute(`INSERT INTO users (username, email, first_name, last_name, age) 
        VALUES (${user.username}, ${user.email}, ${user.firstName}, ${user.lastName}, ${user.age})`);
}

# Retrieves a user by their ID from the database
# + id - The unique identifier of the user
# + return - User record if found, error if not found or query fails
public function getUserById(int id) returns User|error {
    io:println("Debug: Getting user with ID: ", id);
    
    // Test connection first to ensure database is accessible
    stream<record {}, error?> testResult = dbClient->query(`SELECT 1 as test`);
    record {}? testRow = check testResult.next();
    check testResult.close();
    io:println("Debug: Connection test result: ", testRow);
    
    // Query the user data
    stream<record {}, error?> result = dbClient->query(`SELECT * FROM users WHERE id = ${id}`);
    record {}? row = check result.next();
    io:println("Debug: Retrieved row: ", row);
    check result.close();

    if row is record {} {
        io:println("Debug: Row found, processing...");
        
        // Map the database row to a User record
        record {} userData = <record {}>row["value"];
        
        User user = {
            id: <int>userData["id"],
            username: <string>userData["username"],
            email: <string>userData["email"],
            firstName: <string>userData["first_name"],
            lastName: <string>userData["last_name"],
            age: <int>userData["age"]
        };
        io:println("Debug: Created user object: ", user);
        return user;
    }

    io:println("Debug: No row found");
    return error("User not found");
}

# Searches for users by a partial username match
# Uses SQL LIKE operator for pattern matching
# + pattern - The username pattern to search for
# + return - Array of matching users or error if query fails
public function searchUsersByUsername(string pattern) returns User[]|error {
    // Query users with username matching the pattern
    stream<record {}, error?> result = dbClient->query(`SELECT * FROM users WHERE username LIKE ${"%" + pattern + "%"}`);
    User[] users = [];

    // Process each matching row
    check result.forEach(function(record {} row) {
        // Safe type casting with null checks for each field
        anydata idValue = row["id"];
        anydata usernameValue = row["username"];
        anydata emailValue = row["email"];
        anydata firstNameValue = row["first_name"];
        anydata lastNameValue = row["last_name"];
        anydata ageValue = row["age"];

        // Only add the user if all required fields have valid types
        if idValue is int && usernameValue is string && emailValue is string && 
           firstNameValue is string && lastNameValue is string {
            users.push({
                id: idValue,
                username: usernameValue,
                email: emailValue,
                firstName: firstNameValue,
                lastName: lastNameValue,
                age: ageValue is int ? ageValue : () // Handle optional age field
            });
        }
    });
    check result.close();
    return users;
}

# Updates an existing user's information
# + user - The updated user data including the ID
# + return - Error if the update fails
public function updateUser(User user) returns error? {
    _ = check dbClient->execute(`
        UPDATE users 
        SET username = ${user.username}, 
            email = ${user.email}, 
            first_name = ${user.firstName}, 
            last_name = ${user.lastName}, 
            age = ${user.age} 
        WHERE id = ${user.id}
    `);
}

# Deletes a user from the database
# + id - The ID of the user to delete
# + return - Error if the deletion fails
public function deleteUser(int id) returns error? {
    _ = check dbClient->execute(`DELETE FROM users WHERE id = ${id}`);
}

# Retrieves all users from the database
# Returns users sorted by ID for consistent ordering
# + return - Array of all users or error if query fails
public function getAllUsers() returns User[]|error {
    // Query all users ordered by ID
    stream<record {}, error?> result = dbClient->query(`SELECT * FROM users ORDER BY id`);
    User[] users = [];

    // Process each user row
    check result.forEach(function(record {} row) {
        // Safe type casting with null checks for each field
        anydata idValue = row["id"];
        anydata usernameValue = row["username"];
        anydata emailValue = row["email"];
        anydata firstNameValue = row["first_name"];
        anydata lastNameValue = row["last_name"];
        anydata ageValue = row["age"];

        // Only add the user if all required fields have valid types
        if idValue is int && usernameValue is string && emailValue is string && 
           firstNameValue is string && lastNameValue is string {
            users.push({
                id: idValue,
                username: usernameValue,
                email: emailValue,
                firstName: firstNameValue,
                lastName: lastNameValue,
                age: ageValue is int ? ageValue : () // Handle optional age field
            });
        }
    });
    check result.close();
    return users;
}
