CREATE TABLE IF NOT EXISTS `electus_black_market_markets` (
    `id` VARCHAR(64) NOT NULL,
    `label` VARCHAR(128) NOT NULL,
    `source` VARCHAR(32) NOT NULL DEFAULT 'ui',
    `zone_id` INT NULL DEFAULT NULL,
    `enabled` TINYINT(1) NOT NULL DEFAULT 1,
    `npc_model` VARCHAR(64) NULL DEFAULT NULL,
    `npc_coords` LONGTEXT NULL DEFAULT NULL,
    `npc_scenario` VARCHAR(96) NULL DEFAULT NULL,
    `schedule` LONGTEXT NULL DEFAULT NULL,
    `items` LONGTEXT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `electus_black_market_transactions` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `market_id` VARCHAR(64) NOT NULL,
    `zone_id` INT NULL DEFAULT NULL,
    `identifier` VARCHAR(80) NOT NULL,
    `item` VARCHAR(80) NOT NULL,
    `amount` INT NOT NULL,
    `unit_price` INT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `market_id` (`market_id`),
    INDEX `market_item_created` (`market_id`, `item`, `created_at`),
    INDEX `identifier` (`identifier`)
);
