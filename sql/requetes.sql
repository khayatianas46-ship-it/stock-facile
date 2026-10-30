
-- Q1.5.1 : Afficher tous les produits
SELECT * FROM produits;

-- Q1.5.2 : Produits en rupture de stock
SELECT * FROM produits
WHERE quantite = 0;

-- Q1.5.3 : Trier les produits du plus cher au moins cher
SELECT * FROM produits
ORDER BY prix DESC;

-- Q1.5.4 : Afficher les produits avec leur catégorie
SELECT produits.nom, categories.nom AS categorie
FROM produits
INNER JOIN categories
ON produits.categorie_id = categories.id;

-- Q1.5.5 : Nombre de produits par catégorie
SELECT categories.nom, COUNT(produits.id) AS nombre_produits
FROM categories
INNER JOIN produits
ON categories.id = produits.categorie_id
GROUP BY categories.id;

-- Q1.5.6 : Valeur totale du stock
SELECT SUM(prix * quantite) AS valeur_totale_stock
FROM produits;
