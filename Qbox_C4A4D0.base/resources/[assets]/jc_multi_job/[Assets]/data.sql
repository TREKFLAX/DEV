
CREATE TABLE IF NOT EXISTS `jotadev_multijob_player` (
  `identifier` varchar(50) NOT NULL,
  `jobname` varchar(50) NOT NULL,
  `isactive` tinyint(1) NOT NULL DEFAULT 0,
  `duty` tinyint(1) NOT NULL DEFAULT 0,
  `dutyseconds` int(11) NOT NULL DEFAULT 0,
  `playername` varchar(100) DEFAULT NULL,
  `favorite` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`, `jobname`),
  KEY `idx_identifier_isactive` (`identifier`, `isactive`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE IF NOT EXISTS `jotadev_multijob_slots` (
  `identifier` varchar(50) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
