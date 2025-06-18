// Contains SQL query strings

public const string INSERT_USER = 
    "INSERT INTO users (username, email, first_name, last_name, age) VALUES (?, ?, ?, ?, ?)";

public const string GET_USER_BY_ID = 
    "SELECT * FROM users WHERE id = ?";

public const string SEARCH_USERS_BY_USERNAME = 
    "SELECT * FROM users WHERE username LIKE ?";

public const string UPDATE_USER = 
    "UPDATE users SET username = ?, email = ?, first_name = ?, last_name = ?, age = ? WHERE id = ?";

public const string DELETE_USER = 
    "DELETE FROM users WHERE id = ?";