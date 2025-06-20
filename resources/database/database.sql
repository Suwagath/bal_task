-- Users table schema
-- Stores user information with auto-incrementing ID
CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier
    username VARCHAR(50) NOT NULL UNIQUE,        -- Unique username
    email VARCHAR(100) NOT NULL UNIQUE,          -- Unique email address
    first_name VARCHAR(50) NOT NULL,             -- User's first name
    last_name VARCHAR(50) NOT NULL,              -- User's last name
    age INT                                      -- Optional age
); 

-- Sample data for testing
-- Inserts 5 test users with different attributes
INSERT INTO users (username, email, first_name, last_name, age) VALUES
    ('johndoe', 'john.doe@email.com', 'John', 'Doe', 30),
    ('janedick', 'jane.doe@email.com', 'Jane', 'Dick', 28),
    ('bobsmith', 'bob.smith@email.com', 'Bob', 'Smith', 35),
    ('alicejones', 'alice.jones@email.com', 'Alice', 'Jones', 25),
    ('mikebrown', 'mike.brown@email.com', 'Mike', 'Brown', 42);
