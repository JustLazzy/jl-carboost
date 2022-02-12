CREATE TABLE IF NOT EXISTS `bennys_shop` (
    `citizenid` varchar(50) DEFAULT NULL,
    `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
    PRIMARY KEY (`citizenid`),
    KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;