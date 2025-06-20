import ballerina/test;
import ballerina/http;
import bal_task.database as db;

# Test configuration constants
# The service will run on this port during tests
const int TEST_PORT = 8081;
# Base URL for the test HTTP client
const string TEST_URL = "http://localhost:8081";

# Test suite initialization
# This function runs before all tests
@test:BeforeSuite
function startService() returns error? {
    // Service is automatically started by 'bal test'
}

# Tests the GET /users endpoint
# Verifies that the endpoint returns at least one user
@test:Config {
    groups: ["users"]
}
function testGetAllUsers() returns error? {
    http:Client testClient = check new (TEST_URL);
    db:User[] users = check testClient->/users;
    test:assertTrue(users.length() >= 1, "Expected at least 1 user");
}

# Tests the GET /users/id/[userId] endpoint
# Verifies that we can retrieve a specific user by ID
@test:Config {
    groups: ["users"]
}
function testGetUserById() returns error? {
    http:Client testClient = check new (TEST_URL);
    json response = check testClient->/users/id/[1];
    db:User user = check response.cloneWithType();
    test:assertEquals(user.username, "johndoe", "Expected to find user johndoe");
}

# Tests the POST /users/add endpoint
# Creates a new user and verifies it was added successfully
@test:Config {
    groups: ["users"]
}
function testCreateUser() returns error? {
    http:Client testClient = check new (TEST_URL);
    db:UserInput newUser = {
        username: "testuser",
        email: "test@example.com",
        firstName: "Test",
        lastName: "User",
        age: 25
    };
    
    json response = check testClient->/users/add.post(newUser);
    test:assertEquals(response.message, "User added successfully.", "Expected successful user creation");
    
    // Verify user was created
    json searchResponse = check testClient->/users/search(username = "testuser");
    db:User[] users = check searchResponse.cloneWithType();
    test:assertTrue(users.length() == 1, "Expected to find newly created user");
    test:assertEquals(users[0].email, "test@example.com", "Expected matching email for new user");
}

# Tests the PUT /users endpoint
# Updates an existing user and verifies the changes
# Depends on testCreateUser to ensure there's a user to update
@test:Config {
    groups: ["users"],
    dependsOn: [testCreateUser]
}
function testUpdateUser() returns error? {
    http:Client testClient = check new (TEST_URL);
    
    // First get the user we want to update
    json searchResponse = check testClient->/users/search(username = "testuser");
    db:User[] users = check searchResponse.cloneWithType();
    test:assertTrue(users.length() == 1, "Expected to find user to update");
    
    // Update the user
    db:User userToUpdate = users[0];
    userToUpdate.email = "updated@example.com";
    
    json response = check testClient->/users.put(userToUpdate);
    test:assertEquals(response.message, "User updated successfully.", "Expected successful user update");
    
    // Verify update
    json verifyResponse = check testClient->/users/id/[userToUpdate.id];
    db:User updatedUser = check verifyResponse.cloneWithType();
    test:assertEquals(updatedUser.email, "updated@example.com", "Expected email to be updated");
}

# Tests the DELETE /users/id/[userId] endpoint
# Deletes a user and verifies they were removed
# Depends on testUpdateUser to ensure the test runs after updates
@test:Config {
    groups: ["users"],
    dependsOn: [testUpdateUser]
}
function testDeleteUser() returns error? {
    http:Client testClient = check new (TEST_URL);
    
    // First get the user we want to delete
    json searchResponse = check testClient->/users/search(username = "testuser");
    db:User[] users = check searchResponse.cloneWithType();
    test:assertTrue(users.length() == 1, "Expected to find user to delete");
    
    // Delete the user
    json response = check testClient->/users/id/[users[0].id].delete();
    test:assertEquals(response.message, "User deleted successfully.", "Expected successful user deletion");
    
    // Verify deletion
    json verifyResponse = check testClient->/users/search(username = "testuser");
    db:User[] remainingUsers = check verifyResponse.cloneWithType();
    test:assertTrue(remainingUsers.length() == 0, "Expected user to be deleted");
}
