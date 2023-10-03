INSERT INTO `addon_account` (name, label, shared) VALUES
    ('society_ammunation', 'Armurier', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
    ('society_ammunation', 'Armurier', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
    ('ammunation',0,'employee','Employée',0,'{}','{}'),
    ('ammunation',1,'head-team','Chef Equipe',0,'{}','{}'),
    ('ammunation',2,'human-resource','DRH',0,'{}','{}'),
    ('ammunation',3,'second','Co-Patron',0,'{}','{}'),
    ('ammunation',4,'boss','Patron',0,'{}','{}')
;

INSERT INTO `jobs` (name, label) VALUES
    ('ammunation','Armurier')
;