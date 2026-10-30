BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "categories" (
	"id"	INTEGER,
	"nom"	TEXT NOT NULL UNIQUE,
	"description"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "produits" (
	"id"	INTEGER,
	"nom"	TEXT NOT NULL,
	"prix"	REAL NOT NULL CHECK("prix" >= 0),
	"quantite"	INTEGER NOT NULL DEFAULT 0 CHECK("quantite" >= 0),
	"disponible"	INTEGER NOT NULL DEFAULT 1,
	"date_ajout"	TEXT NOT NULL,
	"categorie_id"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("categorie_id") REFERENCES "categories"("id") ON DELETE RESTRICT
);
COMMIT;
