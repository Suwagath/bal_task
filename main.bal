import ballerina/http;
import bal_task.database as db;
import ballerina/os;

# Port configuration for the HTTP service
# Can be overridden via Config.toml
configurable int serverPort = 8080;

# User Management REST Service
# Provides CRUD operations for managing users in the system
service /users on new http:Listener(os:getEnv("BAL_TEST_MODE") != "" ? 8081 : serverPort) {

    # Creates a new user in the system
    # + caller - The HTTP caller object
    # + req - The HTTP request containing user data
    # + return - Error if operation fails
    resource function post add(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        db:UserInput user = check payload.cloneWithType();
        check db:addUser(user);
        check caller->respond({ message: "User added successfully." });
    }

    # Retrieves a user by their ID
    # + caller - The HTTP caller object
    # + req - The HTTP request
    # + userId - ID of the user to retrieve
    # + return - Error if operation fails
    resource function get id/[int userId](http:Caller caller, http:Request req) returns error? {
        db:User|error user = db:getUserById(userId);
        if user is db:User {
            check caller->respond(user);
        } else {
            check caller->respond({ message: "User not found." });
        }
    }

    # Searches for users by username
    # + caller - The HTTP caller object
    # + req - The HTTP request
    # + username - Username to search for
    # + return - Error if operation fails
    resource function get search(http:Caller caller, http:Request req, string username) returns error? {
        db:User[] users = check db:searchUsersByUsername(username);
        check caller->respond(users);
    }

    # Retrieves all users in the system
    # + return - Array of users or error if operation fails
    resource function get .() returns db:User[]|error {
        return db:getAllUsers();
    }

    # Updates an existing user
    # + user - Updated user data
    # + return - Success message or error if operation fails
    resource function put .(@http:Payload db:User user) returns json|error {
        check db:updateUser(user);
        return { message: "User updated successfully." };
    }

    # Deletes a user by their ID
    # + userId - ID of the user to delete
    # + return - Success message or error if operation fails
    resource function delete id/[int userId]() returns json|error {
        check db:deleteUser(userId);
        return { message: "User deleted successfully." };
    }
}