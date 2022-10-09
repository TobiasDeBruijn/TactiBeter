CREATE TABLE users (
    name VARCHAR(64) NOT NULL,
    nonce BLOB NOT NULL,
    cipher BLOB NOT NULL,
    PRIMARY KEY (name)
);

CREATE TABLE sessions (
    id VARCHAR(32) NOT NULL,
    name VARCHAR(64) NOT NULL,
    expiry BIGINT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (name) REFERENCES users(name)
);