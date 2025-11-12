-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3386
-- Generation Time: Nov 12, 2025 at 07:43 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `light__csdl`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `parent_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `name`, `parent_id`) VALUES
(1, 'Chiếu sáng trong nhà', NULL),
(2, 'Chiếu sáng ngoài trời', NULL),
(3, 'Đèn chùm', 1),
(4, 'Đèn tường', 1),
(5, 'Đèn bàn', 1),
(6, 'Đèn ốp trần', 1),
(7, 'Đèn sân vườn', 2),
(8, 'Đèn pha', 2),
(9, 'Đèn trụ cổng', 2);

-- --------------------------------------------------------

--
-- Table structure for table `emailotp`
--

CREATE TABLE `emailotp` (
  `otp_id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `otp_code` varchar(6) NOT NULL,
  `expire_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `emailotp`
--

INSERT INTO `emailotp` (`otp_id`, `email`, `otp_code`, `expire_at`) VALUES
(5, 'govidod500@fermiro.com', '606914', '2025-11-12 02:25:27');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `name`, `email`, `message`, `created_at`) VALUES
(1, 'Homei', 'hoangngocduythptlucnam@gmail.com', 'dsds', '2025-11-05 03:04:43'),
(2, 'Phạm Anh Núi', 'duy@example.com', 'nhin cai gi', '2025-11-11 02:07:43');

-- --------------------------------------------------------

--
-- Table structure for table `orderdetails`
--

CREATE TABLE `orderdetails` (
  `detail_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orderdetails`
--

INSERT INTO `orderdetails` (`detail_id`, `order_id`, `product_id`, `quantity`, `price`) VALUES
(1, 1, 1, 1, 1500000.00),
(2, 2, 2, 2, 2200000.00),
(3, 3, 3, 1, 1800000.00),
(4, 4, 4, 1, 2500000.00),
(5, 5, 5, 3, 3200000.00),
(6, 6, 6, 2, 2750000.00),
(7, 7, 7, 1, 1500000.00),
(8, 8, 8, 1, 680000.00),
(9, 9, 9, 1, 530000.00),
(10, 10, 10, 2, 670000.00),
(11, 11, 11, 1, 4285000.00),
(12, 12, 12, 1, 2010000.00),
(13, 13, 13, 2, 2680000.00),
(14, 14, 14, 1, 2010000.00),
(15, 15, 15, 1, 240000.00),
(16, 16, 16, 1, 2500000.00),
(17, 17, 17, 1, 1500000.00);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `payment_id` int(11) NOT NULL,
  `shipping_address` varchar(255) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `order_date` timestamp NULL DEFAULT current_timestamp(),
  `status` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT 'Chờ duyệt',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `payment_id`, `shipping_address`, `total_price`, `order_date`, `status`, `created_at`) VALUES
(1, 4, 1, '123 Main St, Hanoi', 1500000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(2, 5, 2, '456 Elm St, HCM', 2200000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(3, 6, 1, '789 Oak St, Da Nang', 1800000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(4, 7, 2, '321 Pine St, Hanoi', 2500000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(5, 8, 1, '654 Maple St, HCM', 3200000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(6, 9, 2, '852 Cherry St, Da Nang', 2750000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(7, 10, 1, '159 Walnut St, Hanoi', 1500000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(8, 11, 2, '357 Chestnut St, HCM', 680000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(9, 12, 1, '951 Birch St, Da Nang', 530000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(10, 13, 2, '753 Poplar St, Hanoi', 670000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(11, 14, 1, '456 Sycamore St, HCM', 4285000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(12, 15, 2, '123 Fir St, Da Nang', 2010000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(13, 16, 1, '789 Larch St, Hanoi', 2680000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(14, 17, 2, '321 Willow St, HCM', 2010000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(15, 18, 1, '654 Aspen St, Da Nang', 240000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(16, 19, 2, '852 Magnolia St, Hanoi', 2500000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19'),
(17, 20, 1, '159 Dogwood St, HCM', 1500000.00, '2025-11-11 12:40:19', 'Chờ duyệt', '2025-11-11 19:40:19');

-- --------------------------------------------------------

--
-- Table structure for table `payment_methods`
--

CREATE TABLE `payment_methods` (
  `payment_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment_methods`
--

INSERT INTO `payment_methods` (`payment_id`, `name`, `description`) VALUES
(1, 'Chuyển khoản', 'Thanh toán qua ngân hàng'),
(2, 'COD', 'Thanh toán khi nhận hàng');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `manufacturer` varchar(100) DEFAULT NULL,
  `quantity` int(11) DEFAULT 0,
  `sold_quantity` int(11) DEFAULT 0,
  `image_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `category_id`, `name`, `description`, `price`, `manufacturer`, `quantity`, `sold_quantity`, `image_path`) VALUES
(1, 3, 'Đèn chùm pha lê sang trọng', 'Đèn chùm pha lê cao cấp, ánh sáng ấm áp phù hợp phòng khách.', 2500000.00, 'Philips', 0, 3, 'images/denchum1.jpg'),
(2, 3, 'Đèn chùm hiện đại 6 bóng', 'Thiết kế hiện đại, chất liệu hợp kim cao cấp.', 2200000.00, 'Rạng Đông', 8, 2, 'images/denchum2.jpg'),
(3, 4, 'Đèn tường đôi trang trí', 'Đèn tường ánh sáng vàng, kiểu dáng cổ điển.', 850000.00, 'Paragon', 12, 4, 'images/dentuong1.jpg'),
(4, 4, 'Đèn tường gương hiện đại', 'Phù hợp phòng ngủ và phòng tắm.', 900000.00, 'Panasonic', 6, 1, 'images/dentuong2.jpg'),
(5, 5, 'Đèn bàn học chống cận', 'Đèn bàn LED 3 chế độ sáng, tiết kiệm điện.', 350000.00, 'Duhal', 15, 7, 'images/denban1.jpg'),
(6, 5, 'Đèn bàn cảm ứng đa năng', 'Đèn LED cảm ứng, sạc USB tiện lợi.', 420000.00, 'Philips', 9, 2, 'images/denban2.jpg'),
(7, 6, 'Đèn ốp trần LED tròn 24W', 'Đèn trần LED siêu sáng, tuổi thọ cao.', 480000.00, 'Duhal', 10, 5, 'images/optran1.jpg'),
(8, 6, 'Đèn ốp trần pha lê ốp nổi', 'Đèn trần pha lê sang trọng, ánh sáng trắng.', 680000.00, 'Paragon', 7, 1, 'images/optran2.jpg'),
(9, 7, 'Đèn sân vườn năng lượng mặt trời', 'Tự sạc ban ngày, chiếu sáng ban đêm tự động.', 520000.00, 'Philips', 20, 10, 'images/sanvuon1.jpg'),
(10, 7, 'Đèn sân vườn trang trí mini', 'Dễ lắp đặt, ánh sáng dịu, thích hợp lối đi.', 290000.00, 'Rạng Đông', 18, 4, 'images/sanvuon2.jpg'),
(11, 8, 'Đèn pha LED 50W ngoài trời', 'Chống nước IP65, ánh sáng trắng mạnh.', 750000.00, 'Duhal', 10, 6, 'images/denpha1.jpg'),
(12, 8, 'Đèn pha năng lượng mặt trời', 'Tự sạc bằng năng lượng mặt trời, tiết kiệm điện.', 950000.00, 'Paragon', 8, 3, 'images/denpha2.jpg'),
(13, 9, 'Đèn trụ cổng inox 25cm', 'Đèn trang trí trụ cổng ngoài trời, chống nước.', 680000.00, 'Panasonic', 6, 2, 'images/trucong1.jpg'),
(14, 9, 'Đèn trụ cổng năng lượng mặt trời', 'Tự động chiếu sáng khi trời tối.', 820000.00, 'Philips', 5, 1, 'images/trucong2.jpg'),
(15, 4, 'Đèn LED Bulb 5W Rạng Đông', 'Tiết kiệm điện, ánh sáng trắng 6500K, tuổi thọ 25.000h', 45000.00, NULL, 164, 28, 'images/den-led-bulb-5w.jpg'),
(16, 4, 'Đèn LED Bulb 9W Philips', 'Công suất 9W, ánh sáng vàng 3000K, bảo hành 2 năm', 65000.00, NULL, 7, 4, 'images/den-led-bulb-9w.jpg'),
(17, 4, 'Đèn LED Bulb 12W Điện Quang', 'Chiếu sáng mạnh, phù hợp phòng khách', 89000.00, NULL, 63, 28, 'images/den-led-bulb-12w.jpg'),
(18, 4, 'Đèn LED Bulb 18W Rạng Đông', 'Tiết kiệm điện, ánh sáng trắng tự nhiên', 115000.00, NULL, 36, 6, 'images/den-led-bulb-18w.jpg'),
(19, 6, 'Đèn ốp trần tròn 24W', 'Đèn ốp trần LED siêu sáng, tiết kiệm điện', 265000.00, NULL, 174, 139, 'images/den-op-tran-tron-24w.jpg'),
(20, 6, 'Đèn ốp trần vuông 18W', 'Thiết kế hiện đại, ánh sáng ấm', 225000.00, NULL, 23, 18, 'images/den-op-tran-vuong-18w.jpg'),
(21, 6, 'Đèn ốp trần cảm biến Rạng Đông', 'Tự động bật khi phát hiện chuyển động', 315000.00, NULL, 109, 4, 'images/den-op-tran-cambien.jpg'),
(22, 6, 'Đèn ốp trần mica cao cấp 36W', 'Trang trí phòng khách, ánh sáng vàng', 420000.00, NULL, 8, 1, 'images/den-op-tran-36w.jpg'),
(23, 8, 'Đèn đường LED 50W Rạng Đông', 'Chiếu sáng ngoài trời, đạt chuẩn IP66', 720000.00, NULL, 56, 14, 'images/den-duong-50w.jpg'),
(24, 8, 'Đèn đường năng lượng mặt trời 100W', 'Tự sạc năng lượng, cảm biến ngày đêm', 890000.00, NULL, 130, 6, 'images/den-duong-nangluong-100w.jpg'),
(25, 8, 'Đèn đường LED 150W Philips', 'Hiệu suất cao, dùng cho khu công nghiệp', 1250000.00, NULL, 144, 50, 'images/den-duong-150w.jpg'),
(26, 8, 'Đèn đường năng lượng 200W', 'Có remote điều khiển, pin lithium cao cấp', 1450000.00, NULL, 184, 166, 'images/den-duong-nangluong-200w.jpg'),
(27, 4, 'Đèn thả trần phong cách Bắc Âu', 'Thiết kế tinh tế, ánh sáng dịu nhẹ', 550000.00, NULL, 180, 139, 'images/den-tha-bac-au.jpg'),
(28, 4, 'Đèn chùm pha lê cao cấp', 'Phù hợp phòng khách, sang trọng', 1350000.00, NULL, 108, 28, 'images/den-chum-pha-le.jpg'),
(29, 4, 'Đèn tường vintage Edison', 'Trang trí quán cà phê, không gian cổ điển', 350000.00, NULL, 115, 75, 'images/den-vintage-edison.jpg'),
(30, 4, 'Đèn bàn học chống cận Rạng Đông', 'Ánh sáng tự nhiên, 3 chế độ sáng', 290000.00, NULL, 72, 0, 'images/den-ban-chong-can.jpg'),
(31, 5, 'Bộ nguồn LED 12V 5A', 'Nguồn tổ ong cho đèn LED, chất lượng cao', 99000.00, NULL, 195, 40, 'images/bo-nguon-12v5a.jpg'),
(32, 5, 'Dây điện lõi đồng Cadivi 2x1.5', 'Dây đôi cách điện PVC, dài 100m', 670000.00, NULL, 179, 108, 'images/day-dien-cadivi-2x1.5.jpg'),
(33, 5, 'Bộ chao đèn treo trần', 'Phụ kiện trang trí, chao nhôm trắng', 145000.00, NULL, 88, 35, 'images/chao-den-treo-tran.jpg'),
(34, 5, 'Đui đèn cảm ứng ánh sáng', 'Tự động bật khi trời tối, tắt khi sáng', 120000.00, NULL, 40, 13, 'images/dui-den-cambien.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `provinces`
--

CREATE TABLE `provinces` (
  `province_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `provinces`
--

INSERT INTO `provinces` (`province_id`, `name`) VALUES
(1, 'TP Hà Nội'),
(2, 'TP Huế'),
(3, 'Quảng Ninh'),
(4, 'Cao Bằng'),
(5, 'Lạng Sơn'),
(6, 'Lai Châu'),
(7, 'Điện Biên'),
(8, 'Sơn La'),
(9, 'Thanh Hóa'),
(10, 'Nghệ An'),
(11, 'Hà Tĩnh'),
(12, 'Tuyên Quang'),
(13, 'Lào Cai'),
(14, 'Thái Nguyên'),
(15, 'Phú Thọ'),
(16, 'Bắc Ninh'),
(17, 'Hưng Yên'),
(18, 'TP Hải Phòng'),
(19, 'Ninh Bình'),
(20, 'Quảng Trị'),
(21, 'TP Đà Nẵng'),
(22, 'Quảng Ngãi'),
(23, 'Gia Lai'),
(24, 'Khánh Hòa'),
(25, 'Lâm Đồng'),
(26, 'Đắk Lắk'),
(27, 'TP Hồ Chí Minh'),
(28, 'Đồng Nai'),
(29, 'Tây Ninh'),
(30, 'TP Cần Thơ'),
(31, 'Vĩnh Long'),
(32, 'Đồng Tháp'),
(33, 'Cà Mau'),
(34, 'An Giang');

-- --------------------------------------------------------

--
-- Table structure for table `shipping_info`
--

CREATE TABLE `shipping_info` (
  `shipping_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `receiver_name` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `province_id` int(11) NOT NULL,
  `address` varchar(255) NOT NULL,
  `district` varchar(100) NOT NULL,
  `ward` varchar(100) NOT NULL,
  `shipping_method` varchar(50) NOT NULL DEFAULT 'standard',
  `shipping_fee` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('pending','shipped','delivered','cancelled') NOT NULL DEFAULT 'pending',
  `invoice_company` varchar(255) DEFAULT NULL,
  `tax_code` varchar(50) DEFAULT NULL,
  `tax_email` varchar(100) DEFAULT NULL,
  `note` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shipping_info`
--

INSERT INTO `shipping_info` (`shipping_id`, `order_id`, `receiver_name`, `phone`, `province_id`, `address`, `district`, `ward`, `shipping_method`, `shipping_fee`, `status`, `invoice_company`, `tax_code`, `tax_email`, `note`, `created_at`, `updated_at`) VALUES
(1, 1, 'User Four', '0911000004', 1, '123 Main St', 'Hoàn Kiếm', 'Phúc Tân', 'standard', 30000.00, 'pending', NULL, NULL, NULL, 'Giao giờ hành chính', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(2, 2, 'User Five', '0911000005', 27, '456 Elm St', 'Quận 1', 'Bến Nghé', 'express', 50000.00, 'pending', 'Cty ABC', '123456789', 'abc@example.com', 'Gọi trước khi giao', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(3, 3, 'User Six', '0911000006', 21, '789 Oak St', 'Hải Châu', 'Thạch Thang', 'standard', 40000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(4, 4, 'User Seven', '0911000007', 1, '321 Pine St', 'Ba Đình', 'Điện Biên', 'standard', 30000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(5, 5, 'User Eight', '0911000008', 27, '654 Maple St', 'Quận 1', 'Bến Nghé', 'express', 50000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(6, 6, 'User Nine', '0911000009', 21, '852 Cherry St', 'Hải Châu', 'Thạch Thang', 'standard', 40000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(7, 7, 'User Ten', '0911000010', 1, '159 Walnut St', 'Hoàn Kiếm', 'Phúc Tân', 'standard', 30000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(8, 8, 'User Eleven', '0911000011', 27, '357 Chestnut St', 'Quận 1', 'Bến Nghé', 'express', 50000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(9, 9, 'User Twelve', '0911000012', 21, '951 Birch St', 'Hải Châu', 'Thạch Thang', 'standard', 40000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(10, 10, 'User Thirteen', '0911000013', 1, '753 Poplar St', 'Hoàn Kiếm', 'Phúc Tân', 'standard', 30000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(11, 11, 'User Fourteen', '0911000014', 27, '456 Sycamore St', 'Quận 1', 'Bến Nghé', 'express', 50000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(12, 12, 'User Fifteen', '0911000015', 21, '123 Fir St', 'Hải Châu', 'Thạch Thang', 'standard', 40000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(13, 13, 'User Sixteen', '0911000016', 1, '789 Larch St', 'Hoàn Kiếm', 'Phúc Tân', 'standard', 30000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(14, 14, 'User Seventeen', '0911000017', 27, '321 Willow St', 'Quận 1', 'Bến Nghé', 'express', 50000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(15, 15, 'User Eighteen', '0911000018', 21, '654 Aspen St', 'Hải Châu', 'Thạch Thang', 'standard', 40000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(16, 16, 'User Nineteen', '0911000019', 1, '852 Magnolia St', 'Hoàn Kiếm', 'Phúc Tân', 'standard', 30000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19'),
(17, 17, 'User Twenty', '0911000020', 27, '159 Dogwood St', 'Quận 1', 'Bến Nghé', 'express', 50000.00, 'pending', NULL, NULL, NULL, '', '2025-11-11 12:40:19', '2025-11-11 12:40:19');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `phoneNumber` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `full_name`, `email`, `password_hash`, `role`, `created_at`, `phoneNumber`) VALUES
(1, 'Admin One', 'admin1@example.com', '123456', 'admin', '2025-11-11 12:40:19', '0911000001'),
(2, 'Admin Two', 'admin2@example.com', '123456', 'admin', '2025-11-11 12:40:19', '0911000002'),
(3, 'Admin Three', 'admin3@example.com', '123456', 'admin', '2025-11-11 12:40:19', '0911000003'),
(4, 'User Four', 'user4@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000004'),
(5, 'User Five', 'user5@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000005'),
(6, 'User Six', 'user6@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000006'),
(7, 'User Seven', 'user7@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000007'),
(8, 'User Eight', 'user8@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000008'),
(9, 'User Nine', 'user9@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000009'),
(10, 'User Ten', 'user10@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000010'),
(11, 'User Eleven', 'user11@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000011'),
(12, 'User Twelve', 'user12@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000012'),
(13, 'User Thirteen', 'user13@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000013'),
(14, 'User Fourteen', 'user14@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000014'),
(15, 'User Fifteen', 'user15@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000015'),
(16, 'User Sixteen', 'user16@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000016'),
(17, 'User Seventeen', 'user17@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000017'),
(18, 'User Eighteen', 'user18@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000018'),
(19, 'User Nineteen', 'user19@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000019'),
(20, 'User Twenty', 'user20@example.com', '123456', 'user', '2025-11-11 12:40:19', '0911000020'),
(21, 'tranh', 'lopa59733@gmail.com', '123', 'user', '2025-11-12 02:21:45', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexes for table `emailotp`
--
ALTER TABLE `emailotp`
  ADD PRIMARY KEY (`otp_id`),
  ADD UNIQUE KEY `uniq_email` (`email`(50));

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD PRIMARY KEY (`detail_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `fk_orders_payment` (`payment_id`);

--
-- Indexes for table `payment_methods`
--
ALTER TABLE `payment_methods`
  ADD PRIMARY KEY (`payment_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `provinces`
--
ALTER TABLE `provinces`
  ADD PRIMARY KEY (`province_id`);

--
-- Indexes for table `shipping_info`
--
ALTER TABLE `shipping_info`
  ADD PRIMARY KEY (`shipping_id`),
  ADD KEY `fk_shipping_order` (`order_id`),
  ADD KEY `fk_shipping_province` (`province_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `emailotp`
--
ALTER TABLE `emailotp`
  MODIFY `otp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `orderdetails`
--
ALTER TABLE `orderdetails`
  MODIFY `detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `payment_methods`
--
ALTER TABLE `payment_methods`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `provinces`
--
ALTER TABLE `provinces`
  MODIFY `province_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `shipping_info`
--
ALTER TABLE `shipping_info`
  MODIFY `shipping_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL;

--
-- Constraints for table `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_payment` FOREIGN KEY (`payment_id`) REFERENCES `payment_methods` (`payment_id`),
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `shipping_info`
--
ALTER TABLE `shipping_info`
  ADD CONSTRAINT `fk_shipping_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_shipping_province` FOREIGN KEY (`province_id`) REFERENCES `provinces` (`province_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
