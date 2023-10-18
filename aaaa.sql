-- --------------------------------------------------------
-- Hôte:                         127.0.0.1
-- Version du serveur:           10.4.28-MariaDB - mariadb.org binary distribution
-- SE du serveur:                Win64
-- HeidiSQL Version:             12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Listage de la structure de la base pour wwolf
CREATE DATABASE IF NOT EXISTS `wwolf` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `wwolf`;

-- Listage de la structure de la table wwolf. addon_account
CREATE TABLE IF NOT EXISTS `addon_account` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.addon_account : ~4 rows (environ)
INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('bank_savings', 'Savings account', 0),
	('caution', 'caution', 0),
	('society_ambulance', 'EMS', 1),
	('society_ammunation', 'Armurier', 1),
	('society_illegalseller', 'Vendeur Arme', 1);

-- Listage de la structure de la table wwolf. addon_account_data
CREATE TABLE IF NOT EXISTS `addon_account_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_name` varchar(100) DEFAULT NULL,
  `money` int(11) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_addon_account_data_account_name_owner` (`account_name`,`owner`),
  KEY `index_addon_account_data_account_name` (`account_name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.addon_account_data : ~5 rows (environ)
INSERT INTO `addon_account_data` (`id`, `account_name`, `money`, `owner`) VALUES
	(9, 'society_ambulance', 5000, NULL),
	(10, 'society_ammunation', 0, NULL),
	(11, 'society_illegalseller', 0, NULL),
	(12, 'bank_savings', 0, '525fa2ba075115294b0606735621fca0282600d0'),
	(13, 'caution', 0, '525fa2ba075115294b0606735621fca0282600d0');

-- Listage de la structure de la table wwolf. addon_inventory
CREATE TABLE IF NOT EXISTS `addon_inventory` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.addon_inventory : ~0 rows (environ)

-- Listage de la structure de la table wwolf. addon_inventory_items
CREATE TABLE IF NOT EXISTS `addon_inventory_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inventory_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `count` int(11) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_addon_inventory_items_inventory_name_name` (`inventory_name`,`name`),
  KEY `index_addon_inventory_items_inventory_name_name_owner` (`inventory_name`,`name`,`owner`),
  KEY `index_addon_inventory_inventory_name` (`inventory_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.addon_inventory_items : ~0 rows (environ)

-- Listage de la structure de la table wwolf. billing
CREATE TABLE IF NOT EXISTS `billing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `sender` varchar(60) NOT NULL,
  `target_type` varchar(50) NOT NULL,
  `target` varchar(60) NOT NULL,
  `label` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table wwolf.billing : ~0 rows (environ)

-- Listage de la structure de la table wwolf. blips
CREATE TABLE IF NOT EXISTS `blips` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `blip_name` varchar(255) NOT NULL,
  `blip_sprite` int(11) NOT NULL,
  `blip_size` float NOT NULL,
  `blip_color` int(11) NOT NULL,
  `blip_alpha` int(11) NOT NULL,
  `blip_coords` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.blips : ~0 rows (environ)

-- Listage de la structure de la table wwolf. datastore
CREATE TABLE IF NOT EXISTS `datastore` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.datastore : ~7 rows (environ)
INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
	('property', 'Property', 0),
	('society_ambulance', 'EMS', 1),
	('society_ammunation', 'Armurier', 1),
	('society_illegalseller', 'Vendeur Arme', 1),
	('user_ears', 'Ears', 0),
	('user_glasses', 'Glasses', 0),
	('user_helmet', 'Helmet', 0),
	('user_mask', 'Mask', 0);

-- Listage de la structure de la table wwolf. datastore_data
CREATE TABLE IF NOT EXISTS `datastore_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_datastore_data_name_owner` (`name`,`owner`),
  KEY `index_datastore_data_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.datastore_data : ~9 rows (environ)
INSERT INTO `datastore_data` (`id`, `name`, `owner`, `data`) VALUES
	(5, 'property', NULL, '{}'),
	(6, 'society_ambulance', NULL, '\'{}\''),
	(7, 'society_ammunation', NULL, '\'{}\''),
	(8, 'society_illegalseller', NULL, '\'{}\''),
	(9, 'user_glasses', '525fa2ba075115294b0606735621fca0282600d0', '{}'),
	(10, 'property', '525fa2ba075115294b0606735621fca0282600d0', '{}'),
	(11, 'user_ears', '525fa2ba075115294b0606735621fca0282600d0', '{}'),
	(12, 'user_helmet', '525fa2ba075115294b0606735621fca0282600d0', '{}'),
	(13, 'user_mask', '525fa2ba075115294b0606735621fca0282600d0', '{}');

-- Listage de la structure de la table wwolf. dpkeybinds
CREATE TABLE IF NOT EXISTS `dpkeybinds` (
  `id` varchar(50) DEFAULT NULL,
  `keybind1` varchar(50) DEFAULT 'num4',
  `emote1` varchar(255) DEFAULT '',
  `keybind2` varchar(50) DEFAULT 'num5',
  `emote2` varchar(255) DEFAULT '',
  `keybind3` varchar(50) DEFAULT 'num6',
  `emote3` varchar(255) DEFAULT '',
  `keybind4` varchar(50) DEFAULT 'num7',
  `emote4` varchar(255) DEFAULT '',
  `keybind5` varchar(50) DEFAULT 'num8',
  `emote5` varchar(255) DEFAULT '',
  `keybind6` varchar(50) DEFAULT 'num9',
  `emote6` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Listage des données de la table wwolf.dpkeybinds : ~0 rows (environ)
INSERT INTO `dpkeybinds` (`id`, `keybind1`, `emote1`, `keybind2`, `emote2`, `keybind3`, `emote3`, `keybind4`, `emote4`, `keybind5`, `emote5`, `keybind6`, `emote6`) VALUES
	('license:525fa2ba075115294b0606735621fca0282600d0', 'num4', '', 'num5', '', 'num6', '', 'num7', '', 'num8', '', 'num9', '');

-- Listage de la structure de la table wwolf. items
CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `weight` int(11) NOT NULL DEFAULT 1,
  `rare` tinyint(4) NOT NULL DEFAULT 0,
  `can_remove` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.items : ~33 rows (environ)
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
	('alive_chicken', 'Living chicken', 1, 0, 1),
	('bandage', 'Bandage', 2, 0, 1),
	('blowpipe', 'Blowtorch', 2, 0, 1),
	('bread', 'Bread', 1, 0, 1),
	('cannabis', 'Cannabis', 3, 0, 1),
	('carokit', 'Body Kit', 3, 0, 1),
	('carotool', 'Tools', 2, 0, 1),
	('carwashkit', 'Car Wash Kit', 1, 0, 1),
	('clothe', 'Cloth', 1, 0, 1),
	('copper', 'Copper', 1, 0, 1),
	('cutted_wood', 'Cut wood', 1, 0, 1),
	('diamond', 'Diamond', 1, 0, 1),
	('essence', 'Gas', 1, 0, 1),
	('fabric', 'Fabric', 1, 0, 1),
	('fish', 'Fish', 1, 0, 1),
	('fixkit', 'Repair Kit', 3, 0, 1),
	('fixtool', 'Repair Tools', 2, 0, 1),
	('gazbottle', 'Gas Bottle', 2, 0, 1),
	('gold', 'Gold', 1, 0, 1),
	('iron', 'Iron', 1, 0, 1),
	('marijuana', 'Marijuana', 2, 0, 1),
	('medikit', 'Medikit', 2, 0, 1),
	('packaged_chicken', 'Chicken fillet', 1, 0, 1),
	('packaged_plank', 'Packaged wood', 1, 0, 1),
	('petrol', 'Oil', 1, 0, 1),
	('petrol_raffin', 'Processed oil', 1, 0, 1),
	('phone', 'Phone', 1, 0, 1),
	('radio', 'Radio', 1, 0, 1),
	('slaughtered_chicken', 'Slaughtered chicken', 1, 0, 1),
	('stone', 'Stone', 1, 0, 1),
	('usb_key', 'Clé USB', 1, 0, 1),
	('washed_stone', 'Washed stone', 1, 0, 1),
	('water', 'Water', 1, 0, 1),
	('wood', 'Wood', 1, 0, 1),
	('wool', 'Wool', 1, 0, 1);

-- Listage de la structure de la table wwolf. jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `whitelisted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.jobs : ~4 rows (environ)
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
	('ambulance', 'EMS', 0),
	('ammunation', 'Armurier', 0),
	('illegalseller', 'Vendeur Arme', 0),
	('unemployed', 'Unemployed', 0);

-- Listage de la structure de la table wwolf. job_grades
CREATE TABLE IF NOT EXISTS `job_grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.job_grades : ~11 rows (environ)
INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	(1, 'unemployed', 0, 'unemployed', 'Unemployed', 200, '{}', '{}'),
	(41, 'ambulance', 0, 'second', 'Co-Patron', 0, '{}', '{}'),
	(42, 'ambulance', 1, 'boss', 'Jean Michel', 1000, '{}', '{}'),
	(43, 'ammunation', 0, 'employee', 'Employée', 0, '{}', '{}'),
	(44, 'ammunation', 1, 'head-team', 'Chef Equipe', 0, '{}', '{}'),
	(45, 'ammunation', 2, 'human-resource', 'DRH', 0, '{}', '{}'),
	(46, 'ammunation', 3, 'second', 'Co-Patron', 0, '{}', '{}'),
	(47, 'ammunation', 4, 'boss', 'Patron', 0, '{}', '{}'),
	(48, 'illegalseller', 0, 'employee', 'Employée', 0, '{}', '{}'),
	(49, 'illegalseller', 1, 'head-team', 'Chef Equipe', 0, '{}', '{}'),
	(50, 'illegalseller', 2, 'boss', 'Patron', 0, '{}', '{}');

-- Listage de la structure de la table wwolf. licenses
CREATE TABLE IF NOT EXISTS `licenses` (
  `type` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.licenses : ~6 rows (environ)
INSERT INTO `licenses` (`type`, `label`) VALUES
	('boat', 'Boat License'),
	('dmv', 'Driving Permit'),
	('drive', 'Drivers License'),
	('drive_bike', 'Motorcycle License'),
	('drive_truck', 'Commercial Drivers License'),
	('weapon', 'Weapon License'),
	('weed_processing', 'Weed Processing License');

-- Listage de la structure de la table wwolf. management_outfits
CREATE TABLE IF NOT EXISTS `management_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `minrank` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL DEFAULT 'Cool Outfit',
  `gender` varchar(50) NOT NULL DEFAULT 'male',
  `model` varchar(50) DEFAULT NULL,
  `props` varchar(1000) DEFAULT NULL,
  `components` varchar(1500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.management_outfits : ~0 rows (environ)

-- Listage de la structure de la table wwolf. owned_vehicles
CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `owner` varchar(60) DEFAULT NULL,
  `plate` varchar(12) NOT NULL,
  `vehicle` longtext DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `job` varchar(20) DEFAULT NULL,
  `stored` tinyint(4) NOT NULL DEFAULT 0,
  `parking` varchar(60) DEFAULT NULL,
  `pound` varchar(60) DEFAULT NULL,
  `glovebox` longtext DEFAULT NULL,
  `trunk` longtext DEFAULT NULL,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.owned_vehicles : ~0 rows (environ)

-- Listage de la structure de la table wwolf. ox_inventory
CREATE TABLE IF NOT EXISTS `ox_inventory` (
  `owner` varchar(60) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `data` longtext DEFAULT NULL,
  `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  UNIQUE KEY `owner` (`owner`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.ox_inventory : ~0 rows (environ)

-- Listage de la structure de la table wwolf. playerskins
CREATE TABLE IF NOT EXISTS `playerskins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Listage des données de la table wwolf.playerskins : ~0 rows (environ)

-- Listage de la structure de la table wwolf. player_outfits
CREATE TABLE IF NOT EXISTS `player_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) NOT NULL DEFAULT '0',
  `model` varchar(50) DEFAULT NULL,
  `props` varchar(1000) DEFAULT NULL,
  `components` varchar(1500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `citizenid_outfitname_model` (`citizenid`,`outfitname`,`model`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.player_outfits : ~0 rows (environ)

-- Listage de la structure de la table wwolf. player_outfit_codes
CREATE TABLE IF NOT EXISTS `player_outfit_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `outfitid` int(11) NOT NULL,
  `code` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `FK_player_outfit_codes_player_outfits` (`outfitid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.player_outfit_codes : ~0 rows (environ)

-- Listage de la structure de la table wwolf. society_moneywash
CREATE TABLE IF NOT EXISTS `society_moneywash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `society` varchar(60) NOT NULL,
  `amount` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.society_moneywash : ~0 rows (environ)

-- Listage de la structure de la table wwolf. users
CREATE TABLE IF NOT EXISTS `users` (
  `identifier` varchar(60) NOT NULL,
  `accounts` longtext DEFAULT NULL,
  `group` varchar(50) DEFAULT 'user',
  `inventory` longtext DEFAULT NULL,
  `job` varchar(20) DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT 0,
  `loadout` longtext DEFAULT NULL,
  `metadata` longtext DEFAULT NULL,
  `position` longtext DEFAULT NULL,
  `firstname` varchar(16) DEFAULT NULL,
  `lastname` varchar(16) DEFAULT NULL,
  `dateofbirth` varchar(10) DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `skin` longtext DEFAULT NULL,
  `status` longtext DEFAULT NULL,
  `is_dead` tinyint(1) DEFAULT 0,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `disabled` tinyint(1) DEFAULT 0,
  `last_property` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_seen` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `phone_number` varchar(20) DEFAULT NULL,
  `pincode` int(11) DEFAULT NULL,
  PRIMARY KEY (`identifier`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.users : ~0 rows (environ)
INSERT INTO `users` (`identifier`, `accounts`, `group`, `inventory`, `job`, `job_grade`, `loadout`, `metadata`, `position`, `firstname`, `lastname`, `dateofbirth`, `sex`, `height`, `skin`, `status`, `is_dead`, `id`, `disabled`, `last_property`, `created_at`, `last_seen`, `phone_number`, `pincode`) VALUES
	('525fa2ba075115294b0606735621fca0282600d0', '{"bank":364400,"money":0,"black_money":0}', 'admin', '[]', 'ambulance', 1, '[]', '[]', '{"z":53.240234375,"y":-743.2483520507813,"x":-309.9032897949219}', 'White', 'Wolf', '22/08/1990', 'm', 190, '{"faceFeatures":{"nosePeakLowering":0,"eyesOpening":0,"neckThickness":0,"chinBoneLenght":0,"noseWidth":0,"jawBoneBackSize":0,"chinBoneSize":0,"eyeBrownHigh":0,"jawBoneWidth":0,"chinHole":0,"chinBoneLowering":0,"lipsThickness":0,"noseBoneTwist":0,"nosePeakSize":0,"noseBoneHigh":0,"eyeBrownForward":0,"cheeksBoneWidth":0,"nosePeakHigh":0,"cheeksWidth":0,"cheeksBoneHigh":0},"headBlend":{"shapeSecond":0,"shapeFirst":0,"skinThird":0,"skinFirst":0,"shapeThird":0,"skinSecond":0,"skinMix":0,"thirdMix":0,"shapeMix":0},"tattoos":[],"hair":{"texture":0,"style":0,"color":0,"highlight":0},"model":"mp_m_freemode_01","components":[{"texture":0,"drawable":0,"component_id":0},{"texture":0,"drawable":0,"component_id":1},{"texture":0,"drawable":0,"component_id":2},{"texture":0,"drawable":0,"component_id":3},{"texture":0,"drawable":0,"component_id":4},{"texture":0,"drawable":0,"component_id":5},{"texture":0,"drawable":0,"component_id":6},{"texture":0,"drawable":0,"component_id":7},{"texture":0,"drawable":0,"component_id":8},{"texture":0,"drawable":0,"component_id":9},{"texture":0,"drawable":0,"component_id":10},{"texture":0,"drawable":0,"component_id":11}],"eyeColor":-1,"headOverlays":{"moleAndFreckles":{"opacity":0,"style":0,"color":0,"secondColor":0},"beard":{"opacity":0,"style":0,"color":0,"secondColor":0},"ageing":{"opacity":0,"style":0,"color":0,"secondColor":0},"sunDamage":{"opacity":0,"style":0,"color":0,"secondColor":0},"blush":{"opacity":0,"style":0,"color":0,"secondColor":0},"chestHair":{"opacity":0,"style":0,"color":0,"secondColor":0},"blemishes":{"opacity":0,"style":0,"color":0,"secondColor":0},"eyebrows":{"opacity":0,"style":0,"color":0,"secondColor":0},"complexion":{"opacity":0,"style":0,"color":0,"secondColor":0},"lipstick":{"opacity":0,"style":0,"color":0,"secondColor":0},"bodyBlemishes":{"opacity":0,"style":0,"color":0,"secondColor":0},"makeUp":{"opacity":0,"style":0,"color":0,"secondColor":0}},"props":[{"texture":-1,"drawable":-1,"prop_id":0},{"texture":-1,"drawable":-1,"prop_id":1},{"texture":-1,"drawable":-1,"prop_id":2},{"texture":-1,"drawable":-1,"prop_id":6},{"texture":-1,"drawable":-1,"prop_id":7}]}', '[{"name":"drunk","percent":0.0,"val":0},{"name":"hunger","percent":33.82,"val":338200},{"name":"thirst","percent":50.365,"val":503650}]', 0, 3, 0, NULL, '2023-10-08 22:13:24', '2023-10-13 16:11:56', NULL, NULL);

-- Listage de la structure de la table wwolf. user_licenses
CREATE TABLE IF NOT EXISTS `user_licenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(60) NOT NULL,
  `owner` varchar(60) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.user_licenses : ~0 rows (environ)

-- Listage de la structure de la table wwolf. wwolf_bans
CREATE TABLE IF NOT EXISTS `wwolf_bans` (
  `author` varchar(40) DEFAULT NULL,
  `player` varchar(40) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `ip` varchar(25) DEFAULT NULL,
  `discord` varchar(40) DEFAULT NULL,
  `reason` varchar(100) DEFAULT NULL,
  `ban_time` int(50) NOT NULL,
  `exp_time` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table wwolf.wwolf_bans : ~0 rows (environ)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
