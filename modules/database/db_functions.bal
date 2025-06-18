import ballerina/log;
import ballerina/sql;
import user_crud_service.database;
import user_crud_service.database:db_queries;
import user_crud_service.database:db_connect;

public function insertUser(database:UserInput user) returns error? {
    check db_connect:dbClient->execute(
        db_queries:INSERT_USER,
        user.username,
        user.email,
        user.firstName,
        user.lastName,
        user.age
    );
}

public function getUserById(int id) returns database:User|error {
    stream<record {}, error?> result = db_connect:dbClient->query(db_queries:GET_USER_BY_ID, id);
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

public function searchUsersByUsername(string pattern) returns database:User[]|error {
    stream<record {}, error?> result = db_connect:dbClient->query(
        db_queries:SEARCH_USERS_BY_USERNAME, "%" + pattern + "%");
    database:User[] users = [];
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

public function updateUser(database:User user) returns error? {
    check db_connect:dbClient->execute(
        db_queries:UPDATE_USER,
        user.username,
        user.email,
        user.firstName,
        user.lastName,
        user.age,
        user.id
    );
}

public function deleteUser(int id) returns error? {
    check db_connect:dbClient->execute(db_queries:DELETE_USER, id);
}
