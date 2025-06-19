import ballerina/http;
import user_crud_service.database as db;

service /users on new http:Listener(8080) {

    resource function post insert(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        db:UserInput user = check payload.cloneWithType();
        check db:insertUser(user);
        check caller->respond({ message: "User inserted successfully." });
    }

    resource function get id/[int userId](http:Caller caller, http:Request req) returns error? {
        db:User|error user = db:getUserById(userId);
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

    resource function get .() returns db:User[]|error {
        return db:getAllUsers();
    }

    resource function put .(@http:Payload db:User user) returns json|error {
        check db:updateUser(user);
        return { message: "User updated successfully." };
    }

    resource function delete id/[int userId]() returns json|error {
        check db:deleteUser(userId);
        return { message: "User deleted successfully." };
    }
}