CREATE TABLE pets (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "000 Park Place"), (2, "888 Parkview Loop");

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Nathan", "Li", 1),
  (2, "Charlie", "Schmidt", 1),
  (3, "Edna", "Smith", 2),
  (4, "Petless", "Human", NULL);

INSERT INTO
  pets (id, name, owner_id)
VALUES
  (1, "Oliver", 1),
  (2, "Poe", 2),
  (3, "Patty", 3),
  (4, "Tootie", 3),
  (5, "Bob the Cat", NULL);
