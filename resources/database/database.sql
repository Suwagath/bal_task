CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    age INT
); 

INSERT INTO users (username, email, first_name, last_name, age) VALUES
    ('johndoe', 'john.doe@email.com', 'John', 'Doe', 30),
    ('janedick', 'jane.doe@email.com', 'Jane', 'Dick', 28),
    ('bobsmith', 'bob.smith@email.com', 'Bob', 'Smith', 35),
    ('alicejones', 'alice.jones@email.com', 'Alice', 'Jones', 25),
    ('mikebrown', 'mike.brown@email.com', 'Mike', 'Brown', 42);
