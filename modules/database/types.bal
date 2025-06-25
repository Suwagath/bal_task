# Represents a user in the system
# + id - Unique identifier for the user
# + username - Unique username
# + email - User's email address
# + firstName - User's first name
# + lastName - User's last name
# + age - User's age (optional)
public type User record {
    int id;
    string username;
    string email;
    string firstName;
    string lastName;
    int? age;
};

# Represents input data for creating a new user
# Does not include the ID as it's auto-generated
# + username - Desired username (must be unique)
# + email - User's email address (must be unique)
# + firstName - User's first name
# + lastName - User's last name
# + age - User's age (optional)
public type UserInput record {
    string username;
    string email;
    string firstName;
    string lastName;
    int? age;
};

# Represents an error response
# + message - Error message describing what went wrong
# + cause - Optional cause of the error
public type Error record {
    string message;
    string? cause;
};
