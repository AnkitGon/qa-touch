-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 26, 2025 at 09:03 PM
-- Server version: 8.0.30
-- PHP Version: 7.3.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_interview_ankit`
--

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2025_01_24_173627_create_qa_touch_modules_table', 1),
(6, '2025_01_24_173804_create_qa_touch_test_cases_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'GoogleLogin', '8245693d55674dffcc0e3c230d9327971bcc2852a2be2306a52d3d6424ef76be', '[\"*\"]', NULL, '2025-01-26 15:10:08', '2025-01-26 15:10:08'),
(2, 'App\\Models\\User', 1, 'GoogleLogin', 'de56443cd1cc13a7772fdc58af1db0226a3dc1b24f30dbaee5f9eec27a241c5f', '[\"*\"]', NULL, '2025-01-26 15:16:57', '2025-01-26 15:16:57'),
(3, 'App\\Models\\User', 1, 'GoogleLogin', '3350c069c2d04df544d302fe659b31b108cfd33266b256f6e7f1da81af5a00f4', '[\"*\"]', NULL, '2025-01-26 15:18:20', '2025-01-26 15:18:20');

-- --------------------------------------------------------

--
-- Table structure for table `qa_touch_modules`
--

CREATE TABLE `qa_touch_modules` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint UNSIGNED DEFAULT NULL,
  `module_order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `qa_touch_modules`
--

INSERT INTO `qa_touch_modules` (`id`, `name`, `parent_id`, `module_order`, `created_at`, `updated_at`) VALUES
(1, 'Sport', NULL, 2, '2025-01-26 15:10:31', '2025-01-26 15:18:33'),
(2, 'Economics', NULL, 1, '2025-01-26 15:10:41', '2025-01-26 15:18:33'),
(3, 'Football', 1, 2, '2025-01-26 15:11:00', '2025-01-26 15:18:30'),
(4, 'Tennis', 1, 1, '2025-01-26 15:11:05', '2025-01-26 15:18:30'),
(5, 'Stocks', 2, 0, '2025-01-26 15:11:29', '2025-01-26 15:11:29'),
(6, 'Exports', 2, 0, '2025-01-26 15:11:35', '2025-01-26 15:11:35');

-- --------------------------------------------------------

--
-- Table structure for table `qa_touch_test_cases`
--

CREATE TABLE `qa_touch_test_cases` (
  `id` bigint UNSIGNED NOT NULL,
  `module_id` bigint UNSIGNED NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `attachment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `qa_touch_test_cases`
--

INSERT INTO `qa_touch_test_cases` (`id`, `module_id`, `summary`, `description`, `attachment`, `created_at`, `updated_at`) VALUES
(1, 1, 'Add a new player to the system.', 'Submit the form.', 'attachments/9vpnFdP4Yqf4CJK7Qqj73GCg4UjOcpFD9xhw5vDw.jpg', '2025-01-26 15:13:03', '2025-01-26 15:13:03'),
(2, 3, 'Add a New Football Player', 'Submit the form.', NULL, '2025-01-26 15:14:00', '2025-01-26 15:14:00'),
(3, 4, 'Add a New Tennis Player', 'Submit the form', NULL, '2025-01-26 15:14:21', '2025-01-26 15:14:21'),
(4, 2, 'Add New Economic Indicator', 'Submit the form', NULL, '2025-01-26 15:14:45', '2025-01-26 15:14:45'),
(5, 5, 'Add a New Stock to the System', 'Submit the form', NULL, '2025-01-26 15:15:17', '2025-01-26 15:15:17'),
(6, 6, 'Add New Export Record', 'Submit the form', NULL, '2025-01-26 15:15:45', '2025-01-26 15:15:45');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `google_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `google_id`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Aɴᴋɪᴛ Gᴏɴᴅᴀʟɪʏᴀ', 'ankitgondaliya31@gmail.com', NULL, NULL, '$2y$10$oGbnkUZaFXJ7Vm5HGRm97OOQ3dfpjJA6LCHChBe3mJAubDuTUj1wG', NULL, '2025-01-26 15:10:08', '2025-01-26 15:10:08');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `qa_touch_modules`
--
ALTER TABLE `qa_touch_modules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `qa_touch_modules_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `qa_touch_test_cases`
--
ALTER TABLE `qa_touch_test_cases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `qa_touch_test_cases_module_id_foreign` (`module_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_google_id_index` (`google_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `qa_touch_modules`
--
ALTER TABLE `qa_touch_modules`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `qa_touch_test_cases`
--
ALTER TABLE `qa_touch_test_cases`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `qa_touch_modules`
--
ALTER TABLE `qa_touch_modules`
  ADD CONSTRAINT `qa_touch_modules_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `qa_touch_modules` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `qa_touch_test_cases`
--
ALTER TABLE `qa_touch_test_cases`
  ADD CONSTRAINT `qa_touch_test_cases_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `qa_touch_modules` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
