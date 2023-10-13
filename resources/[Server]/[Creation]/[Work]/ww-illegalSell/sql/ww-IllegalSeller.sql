INSERT INTO `addon_account` (name, label, shared) VALUES
    ('society_illegalseller', 'Vendeur Arme', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
    ('society_illegalseller', 'Vendeur Arme', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
    ('illegalseller',0,'employee','Employée',0,'{}','{}'),
    ('illegalseller',1,'head-team','Chef Equipe',0,'{}','{}'),
    ('illegalseller',2,'boss','Patron',0,'{}','{}')
;

INSERT INTO `jobs` (name, label) VALUES
    ('illegalseller','Vendeur Arme')
;