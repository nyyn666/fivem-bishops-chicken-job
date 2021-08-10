INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_bishops','Bishop's Chicken',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  ('society_bishops','Bishop's Chicken',1)
;

INSERT INTO `jobs` (name, label) VALUES
  ('bishops','Bishop's Chicken')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('bishops',0,'bishops1','bishops',250,'{}','{}'),
;

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('kurczak1', 'Surowy kurczak', 10, 0, 1),
	('kurczak2', 'Usmazony kurczak', 10, 0, 1)
;
