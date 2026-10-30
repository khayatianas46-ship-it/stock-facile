
INSERT INTO categories (nom, description) VALUES
  ('Alimentation', 'Produits secs et conserves'),
  ('Boissons', 'Eaux, jus et sodas'),
  ('Hygiène', 'Savons et produits d''entretien'),
  ('Papeterie', 'Cahiers, stylos et fournitures');

INSERT INTO produits
(nom, prix, quantite, disponible, date_ajout, categorie_id)
VALUES
  ('Huile d''olive 1 L', 18.500, 24, 1, '2026-10-01T09:00:00', 1),
  ('Couscous moyen 1 kg', 2.300, 40, 1, '2026-10-01T09:05:00', 1),
  ('Eau minérale 1,5 L', 0.850, 120, 1, '2026-10-02T10:00:00', 2),
  ('Jus d''orange 1 L', 3.200, 0, 0, '2026-10-02T10:10:00', 2),
  ('Savon de Marseille', 2.900, 15, 1, '2026-10-03T11:00:00', 3),
  ('Cahier 96 pages', 1.600, 60, 1, '2026-10-04T08:30:00', 4);
