-- XAMPP-Lite 8.4.6
-- https://xampplite.sf.net/
-- ----------------------------------------------------------------
-- Server version: 11.4.5-MariaDB-log
-- Date: Mon, 25 Aug 2025 05:47:30 +0000

-- MySQL compatibility and import directives (DO NOT REMOVE)
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Table `users` ==================================================
CREATE TABLE `users` (
  `id` smallint(5) unsigned NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
--


-- Table `expense` ================================================
CREATE TABLE `expense` (
  `id` smallint(5) unsigned NOT NULL,
  `user_id` smallint(8) unsigned NOT NULL,
  `item` varchar(50) NOT NULL,
  `paid` mediumint(9) NOT NULL,
  `date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
--
INSERT INTO `expense` (`id`, `user_id`, `item`, `paid`, `date`) VALUES
  (1,	1,	'lunch',	70,	'2025-08-23 15:40:19'),
  (2,	1,	'coffee',	45,	'2025-08-23 15:42:36'),
  (3,	1,	'rent',	1600,	'2025-08-23 15:43:26'),
  (4,	2,	'lunch',	50,	'2025-08-23 15:43:55'),
  (5,	2,	'bun',	20,	'2025-08-23 15:44:27');



/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

-- Dump completed on: Mon, 25 Aug 2025 05:47:34 +0000
