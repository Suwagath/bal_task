import ballerina/io;

public function addUser(UserInput user) returns error? {
    _ = check dbClient->execute(`INSERT INTO users (username, email, first_name, last_name, age) VALUES (${user.username}, ${user.email}, ${user.firstName}, ${user.lastName}, ${user.age})`);
}

public function getUserById(int id) returns User|error {
    io:println("Debug: Getting user with ID: ", id);
    
    // Test connection first
    stream<record {}, error?> testResult = dbClient->query(`SELECT 1 as test`);
    record {}? testRow = check testResult.next();
    check testResult.close();
    io:println("Debug: Connection test result: ", testRow);
    
    stream<record {}, error?> result = dbClient->query(`SELECT * FROM users WHERE id = ${id}`);
    record {}? row = check result.next();
    io:println("Debug: Retrieved row: ", row);
    check result.close();

    if row is record {} {
        io:println("Debug: Row found, processing...");
        
        // Access the data from the "value" field
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

public function searchUsersByUsername(string pattern) returns User[]|error {
    stream<record {}, error?> result = dbClient->query(`SELECT * FROM users WHERE username LIKE ${"%" + pattern + "%"}`);
    User[] users = [];
    check result.forEach(function(record {} row) {
        // Safe casting with null checks
        anydata idValue = row["id"];
        anydata usernameValue = row["username"];
        anydata emailValue = row["email"];
        anydata firstNameValue = row["first_name"];
        anydata lastNameValue = row["last_name"];
        anydata ageValue = row["age"];

        if idValue is int && usernameValue is string && emailValue is string && 
           firstNameValue is string && lastNameValue is string {
            users.push({
                id: idValue,
                username: usernameValue,
                email: emailValue,
                firstName: firstNameValue,
                lastName: lastNameValue,
                age: ageValue is int ? ageValue : ()
            });
        }
    });
    check result.close();
    return users;
}

public function updateUser(User user) returns error? {
    _ = check dbClient->execute(`UPDATE users SET username = ${user.username}, email = ${user.email}, first_name = ${user.firstName}, last_name = ${user.lastName}, age = ${user.age} WHERE id = ${user.id}`);
}

public function deleteUser(int id) returns error? {
    _ = check dbClient->execute(`DELETE FROM users WHERE id = ${id}`);
}

public function getAllUsers() returns User[]|error {
    stream<record {}, error?> result = dbClient->query(`SELECT * FROM users ORDER BY id`);
    User[] users = [];
    check result.forEach(function(record {} row) {
        // Safe casting with null checks
        anydata idValue = row["id"];
        anydata usernameValue = row["username"];
        anydata emailValue = row["email"];
        anydata firstNameValue = row["first_name"];
        anydata lastNameValue = row["last_name"];
        anydata ageValue = row["age"];

        if idValue is int && usernameValue is string && emailValue is string && 
           firstNameValue is string && lastNameValue is string {
            users.push({
                id: idValue,
                username: usernameValue,
                email: emailValue,
                firstName: firstNameValue,
                lastName: lastNameValue,
                age: ageValue is int ? ageValue : ()
            });
        }
    });
    check result.close();
    return users;
}
