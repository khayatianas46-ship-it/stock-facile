
CREATE TABLE categories (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  nom         TEXT    NOT NULL UNIQUE,
  description TEXT
);

CREATE TABLE produits (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  nom          TEXT    NOT NULL,
  prix         REAL    NOT NULL CHECK (prix >= 0),
  quantite     INTEGER NOT NULL DEFAULT 0 CHECK (quantite >= 0),
  disponible   INTEGER NOT NULL DEFAULT 1,
  date_ajout   TEXT    NOT NULL,
  categorie_id INTEGER NOT NULL,
  FOREIGN KEY (categorie_id) REFERENCES categories(id) ON DELETE RESTRICT
);
