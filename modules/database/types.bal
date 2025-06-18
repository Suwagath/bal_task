import ballerina/time;

public type User record {
    int id;
    string username;
    string email;
    string firstName;
    string lastName;
    int? age;
    time:Utc createdTime;
    time:Utc updatedTime;
};

public type UserInput record {
    string username;
    string email;
    string firstName;
    string lastName;
    int? age;
};

public type Error record {
    string message;
    string? cause;
}; 