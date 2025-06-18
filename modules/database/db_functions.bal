public function insertUser(UserInput user) returns error? {
    _ = check dbClient->execute(`INSERT INTO users (username, email, first_name, last_name, age) VALUES (${user.username}, ${user.email}, ${user.firstName}, ${user.lastName}, ${user.age})`);
}

public function getUserById(int id) returns User|error {
    stream<record {}, error?> result = dbClient->query(`SELECT * FROM users WHERE id = ${id}`);
    record {}? row = check result.next();
    check result.close();

    if row is record {} {
        return {
            id: <int>row["id"],
            username: <string>row["username"],
            email: <string>row["email"],
            firstName: <string>row["first_name"],
            lastName: <string>row["last_name"],
            age: <int?>row["age"]
        };
    }

    return error("User not found");
}

public function searchUsersByUsername(string pattern) returns User[]|error {
    stream<record {}, error?> result = dbClient->query(`SELECT * FROM users WHERE username LIKE ${"%" + pattern + "%"}`);
    User[] users = [];
    error? e = result.forEach(function(record {} row) {
        users.push({
            id: <int>row["id"],
            username: <string>row["username"],
            email: <string>row["email"],
            firstName: <string>row["first_name"],
            lastName: <string>row["last_name"],
            age: <int?>row["age"]
        });
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
