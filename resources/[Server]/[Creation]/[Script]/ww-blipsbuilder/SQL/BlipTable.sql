CREATE TABLE IF NOT EXISTS `blips` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `blip_name` VARCHAR(255) NOT NULL,
    `blip_sprite` INT NOT NULL,
    `blip_size` FLOAT NOT NULL,
    `blip_color` INT NOT NULL,
    `blip_alpha` INT NOT NULL,
    `blip_coords` VARCHAR(255) NOT NULL
);