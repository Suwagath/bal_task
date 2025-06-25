import bal_task.database as db;

import ballerina/http;
import ballerina/os;

# Port configuration for the HTTP service
# Can be overridden via Config.toml
configurable int serverPort = 8080;

# User Management REST Service
# Provides CRUD operations for managing users in the system
service /users on new http:Listener(os:getEnv("BAL_TEST_MODE") != "" ? 8081 : serverPort) {

    # Creates a new user in the system
    # + payload - The user data to create
    # + return - Created(201) response on success or BadRequest(400) on validation failure
    resource function post add(@http:Payload db:UserInput payload) returns http:Created|http:BadRequest|error {
        error? result = db:addUser(payload);
        if result is error {
            return <http:BadRequest>{body: {message: "Failed to add user: " + result.message()}};
        }
        return <http:Created>{body: {message: "User added successfully."}};
    }

    # Retrieves a user by their ID
    # + userId - ID of the user to retrieve
    # + return - User data with OK(200) response or NotFound(404) if user doesn't exist
    resource function get id/[int userId]() returns http:Ok|http:NotFound|error {
        db:User|error user = db:getUserById(userId);
        if user is db:User {
            return <http:Ok>{body: user};
        }
        return <http:NotFound>{body: {message: "User not found."}};
    }

    # Searches for users by username
    # + username - Username to search for
    # + return - OK(200) with matching users or NotFound(404) if no users found
    resource function get search(string username) returns http:Ok|http:NotFound|error {
        db:User[] users = check db:searchUsersByUsername(username);
        if users.length() > 0 {
            return <http:Ok>{body: users};
        }
        return <http:NotFound>{body: {message: "No users found matching the search criteria."}};
    }

    # Retrieves all users in the system
    # + return - OK(200) with array of users or NotFound(404) if no users exist
    resource function get .() returns http:Ok|http:NotFound|error {
        db:User[] users = check db:getAllUsers();
        if users.length() > 0 {
            return <http:Ok>{body: users};
        }
        return <http:NotFound>{body: {message: "No users found in the system."}};
    }

    # Updates an existing user
    # + user - Updated user data
    # + return - OK(200) on successful update or NotFound(404) if user doesn't exist
    resource function put .(@http:Payload db:User user) returns http:Ok|http:NotFound|error {
        error? result = db:updateUser(user);
        if result is error {
            return <http:NotFound>{body: {message: "User not found or update failed."}};
        }
        return <http:Ok>{body: {message: "User updated successfully."}};
    }

    # Deletes a user by their ID
    # + userId - ID of the user to delete
    # + return - OK(200) on successful deletion or NotFound(404) if user doesn't exist
    resource function delete id/[int userId]() returns http:Ok|http:NotFound|error {
        error? result = db:deleteUser(userId);
        if result is error {
            return <http:NotFound>{body: {message: "User not found or deletion failed."}};
        }
        return <http:Ok>{body: {message: "User deleted successfully."}};
    }
}
