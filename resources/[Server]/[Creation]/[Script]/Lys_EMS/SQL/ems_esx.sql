INSERT INTO `addon_account` (name, label, shared) VALUES
    ('society_ambulance', 'EMS', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
    ('society_ambulance', 'EMS', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
    ('ambulance',0,'second','Co-Patron',0,'{}','{}'),
    ('ambulance',1,'boss','Patron',0,'{}','{}')
;

INSERT INTO `jobs` (name, label) VALUES
    ('ambulance','EMS')
;