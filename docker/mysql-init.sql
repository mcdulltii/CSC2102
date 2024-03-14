CREATE TABLE `users` (
  `user_id` CHAR(36) NOT NULL,
  `user_email` VARCHAR(255) NOT NULL,
  `user_password_hashed` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX `idx_user` USING HASH ON `users` (`user_email`, `user_password_hash`);
