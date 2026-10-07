CREATE TABLE IF NOT EXISTS `jotadev_admin_blip_categories` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `jotadev_admin_blips` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(128) NOT NULL,
    `sprite` INT NOT NULL DEFAULT 1,
    `color` INT NOT NULL DEFAULT 0,
    `scale` FLOAT NOT NULL DEFAULT 0.8,
    `short_range` TINYINT(1) NOT NULL DEFAULT 1,
    `category_id` INT NULL DEFAULT NULL,
    `jobs` LONGTEXT NULL,
    `image` MEDIUMTEXT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_blips_category` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
