CREATE TABLE IF NOT EXISTS `bennys_shop` (
  `citizenid` varchar(50) NOT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`citizenid`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `boost_contract` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) DEFAULT NULL,
  `data` text DEFAULT NULL,
  `started` datetime DEFAULT NULL,
  `expire` datetime DEFAULT NULL,
  `onsale` int(11) DEFAULT 0,
  `price` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `owner` (`owner`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb3;

ALTER TABLE player_vehicles ADD COLUMN `vinnumber` VARCHAR(50) NULL;

ALTER TABLE player_vehicles ADD COLUMN `vinscratch` INT(2) DEFAULT 0;