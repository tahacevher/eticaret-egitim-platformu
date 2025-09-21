-- E-ticaret Eğitim Platformu - Tam Veritabanı
-- propalizm.gen.tr

SET FOREIGN_KEY_CHECKS=0;

-- Users Table
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','instructor','student') NOT NULL DEFAULT 'student',
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Programs Table
CREATE TABLE `programs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title_tr` varchar(255) NOT NULL,
  `title_en` varchar(255) NOT NULL,
  `description_tr` text NOT NULL,
  `description_en` text NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `duration_hours` int(11) NOT NULL DEFAULT 0,
  `featured` tinyint(1) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Modules Table
CREATE TABLE `modules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `program_id` bigint(20) unsigned NOT NULL,
  `title_tr` varchar(255) NOT NULL,
  `title_en` varchar(255) NOT NULL,
  `content_tr` text DEFAULT NULL,
  `content_en` text DEFAULT NULL,
  `prerequisites_tr` text DEFAULT NULL,
  `prerequisites_en` text DEFAULT NULL,
  `equipment_tr` text DEFAULT NULL,
  `equipment_en` text DEFAULT NULL,
  `notes_tr` text DEFAULT NULL,
  `notes_en` text DEFAULT NULL,
  `order_index` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `modules_program_id_foreign` (`program_id`),
  CONSTRAINT `modules_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Training Sessions Table
CREATE TABLE `training_sessions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` bigint(20) unsigned NOT NULL,
  `instructor_id` bigint(20) unsigned NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `location_tr` varchar(255) NOT NULL,
  `location_en` varchar(255) NOT NULL,
  `capacity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `enrolled_count` int(11) NOT NULL DEFAULT 0,
  `status` enum('active','completed','cancelled') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `training_sessions_module_id_foreign` (`module_id`),
  KEY `training_sessions_instructor_id_foreign` (`instructor_id`),
  CONSTRAINT `training_sessions_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `training_sessions_instructor_id_foreign` FOREIGN KEY (`instructor_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Products Table
CREATE TABLE `products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name_tr` varchar(255) NOT NULL,
  `name_en` varchar(255) NOT NULL,
  `description_tr` text NOT NULL,
  `description_en` text NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock_quantity` int(11) NOT NULL DEFAULT 0,
  `delivery_time` int(11) NOT NULL DEFAULT 1,
  `images` json DEFAULT NULL,
  `sku` varchar(255) NOT NULL,
  `weight` decimal(8,2) DEFAULT NULL,
  `featured` tinyint(1) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `products_sku_unique` (`sku`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Orders Table
CREATE TABLE `orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `order_number` varchar(255) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `tax_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('pending','paid','cancelled','refunded') NOT NULL DEFAULT 'pending',
  `payment_status` enum('pending','completed','failed') NOT NULL DEFAULT 'pending',
  `payment_method` varchar(255) DEFAULT NULL,
  `paytr_transaction_id` varchar(255) DEFAULT NULL,
  `billing_details` json NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `orders_order_number_unique` (`order_number`),
  KEY `orders_user_id_foreign` (`user_id`),
  CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sample Data
INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Admin User', 'admin@propalizm.gen.tr', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 1, NOW(), NOW());

INSERT INTO `programs` (`id`, `title_tr`, `title_en`, `description_tr`, `description_en`, `duration_hours`, `featured`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Taktik Tabanca Eğitimi', 'Tactical Pistol Training', 'Profesyonel taktik tabanca eğitimi programı', 'Professional tactical pistol training program', 40, 1, 1, NOW(), NOW()),
(2, 'Silahlı Güvenlik Eğitimi', 'Armed Security Training', 'VIP koruma ve silahlı güvenlik eğitimi', 'VIP protection and armed security training', 60, 1, 1, NOW(), NOW());

INSERT INTO `products` (`id`, `name_tr`, `name_en`, `description_tr`, `description_en`, `price`, `stock_quantity`, `sku`, `featured`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Taktik Kemer', 'Tactical Belt', 'Profesyonel taktik kemer sistemi', 'Professional tactical belt system', 299.99, 50, 'TAC-BELT-001', 1, 1, NOW(), NOW()),
(2, 'Eğitim Kiti', 'Training Kit', 'Temel eğitim malzemeleri kiti', 'Basic training materials kit', 149.99, 30, 'TRAIN-KIT-001', 1, 1, NOW(), NOW());

SET FOREIGN_KEY_CHECKS=1;
