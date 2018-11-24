-- enable encryption functions:
CREATE EXTENSION pgcrypto;

-- Tables:

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR NOT NULL,
  encrypted_password VARCHAR NOT NULL
);
-- example usage:
-- INSERT INTO users (username, encrypted_password) VALUES ('myusername', crypt('password-to-save', gen_salt('bf')));
-- UPDATE table SET encrypted_password = crypt('password',gen_salt('bf'));
-- SELECT * FROM users WHERE encrypted_password is NOT NULL AND encrypted_password = crypt('password-to-test', encrypted_password);


