import ballerina/http;
import user_crud_service.database as db;

service /users on new http:Listener(8080) {

    resource function post insert(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        db:UserInput user = check payload.cloneWithType();
        check db:insertUser(user);
        check caller->respond({ message: "User inserted successfully." });
    }

    resource function get getById(http:Caller caller, http:Request req, int id) returns error? {
        db:User|error user = db:getUserById(id);
        if user is db:User {
            check caller->respond(user);
        } else {
            check caller->respond({ message: "User not found." });
        }
    }

    resource function get search(http:Caller caller, http:Request req, string username) returns error? {
        db:User[] users = check db:searchUsersByUsername(username);
        check caller->respond(users);
    }

    resource function put update(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        db:User user = check payload.cloneWithType();
        check db:updateUser(user);
        check caller->respond({ message: "User updated successfully." });
    }

    resource function delete delete(http:Caller caller, http:Request req, int id) returns error? {
        check db:deleteUser(id);
        check caller->respond({ message: "User deleted successfully." });
    }
}
