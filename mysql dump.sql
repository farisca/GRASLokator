-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 10, 2014 at 11:30 PM
-- Server version: 5.5.24-log
-- PHP Version: 5.3.13

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `javniprevoz`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `udaljenosti`( v_lat  decimal(21,20),  v_lon  decimal(21,20),  v_voznja  INT) RETURNS int(11)
    READS SQL DATA
begin
		DECLARE v_tren_stanica INT;
                DECLARE v_slijed_stanica INT;
                
		DECLARE v_linija INT;
        	DECLARE v_udaljenost1 decimal(12,9);
        	DECLARE v_udaljenost2 decimal(12,9);
		DECLARE v_final INT;
		
		DECLARE lat_st1 decimal(12,9);
        	DECLARE lon_st1 decimal(12,9);
		DECLARE lat_st2 decimal(12,9);
        	DECLARE lon_st2 decimal(12,9);
		
		SET v_slijed_stanica = -1;
		SELECT idStanice, idLinije INTO v_tren_stanica, v_linija FROM voznje WHERE idVoznje=v_voznja;
		SELECT idStanice INTO v_slijed_stanica FROM stanice_linije WHERE idLinije=v_linija AND redniBroj=
			(SELECT redniBroj FROM stanice_linije WHERE idStanice=v_tren_stanica)+1;
			
		if v_slijed_stanica = -1 then
			SET v_final=v_tren_stanica;
		else
			SELECT lat, lon INTO lat_st1, lon_st2 FROM stanice WHERE idStanice=v_tren_stanica;
			SELECT lon INTO lon_st1 FROM stanice WHERE idStanice=v_tren_stanica;
			
			SET v_udaljenost1 = (acos(sin((v_lat*pi()/180)) * sin((lat_st1*pi()/180))+cos((v_lat*pi()/180)) * cos((lat_st1*pi()/180)) * cos(((v_lon- lon_st1)* pi()/180))))*180/pi();
			SET v_udaljenost2 = (acos(sin((v_lat*pi()/180)) * sin((lat_st2*pi()/180))+cos((v_lat*pi()/180)) * cos((lat_st2*pi()/180)) * cos(((v_lon- lon_st2)* pi()/180))))*180/pi(); 
		
			if v_udaljenost1 < v_udaljenost2 then
				set v_final=v_tren_stanica;
			else 
				SET v_final=v_slijed_stanica;
			end if;
		end if;
		return (v_final);
	end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `itemi`
--

CREATE TABLE IF NOT EXISTS `itemi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `naziv` varchar(30) COLLATE utf8_slovenian_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_slovenian_ci AUTO_INCREMENT=8 ;

--
-- Dumping data for table `itemi`
--

INSERT INTO `itemi` (`id`, `naziv`) VALUES
(1, 'create'),
(2, 'select'),
(3, 'update'),
(4, 'insert'),
(5, 'delete'),
(6, 'drop'),
(7, 'alter');

-- --------------------------------------------------------

--
-- Table structure for table `korisnici`
--

CREATE TABLE IF NOT EXISTS `korisnici` (
  `idKorisnika` int(11) NOT NULL AUTO_INCREMENT,
  `ime` varchar(50) COLLATE utf8_slovenian_ci NOT NULL,
  `prezime` varchar(50) COLLATE utf8_slovenian_ci NOT NULL,
  `korisnickoIme` varchar(50) COLLATE utf8_slovenian_ci NOT NULL,
  `password` varchar(100) COLLATE utf8_slovenian_ci NOT NULL,
  `idRole` int(11) NOT NULL,
  PRIMARY KEY (`idKorisnika`),
  KEY `idRole` (`idRole`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_slovenian_ci AUTO_INCREMENT=17 ;

--
-- Dumping data for table `korisnici`
--

INSERT INTO `korisnici` (`idKorisnika`, `ime`, `prezime`, `korisnickoIme`, `password`, `idRole`) VALUES
(1, 'Asmir', 'Begovic', 'golman666', 'password', 2),
(2, 'Avdija', 'Vrsajevic', 'xavdijax', '12345', 2),
(3, 'Ermin', 'Bicakcic', 'bixx', '54321', 2),
(4, 'Emir', 'Spahic', 'spaha04', 'dubrovnik', 2),
(5, 'Sead', 'Kolasinac', 'seyo', 'rakija', 2),
(6, 'Ognjen', 'Vranjes', 'ogy', '12345', 2),
(7, 'Muhamed', 'Besic', 'leomessi2', 'ronaldo', 2),
(8, 'Haris', 'Medunjanin', 'reha08', 'baklava', 2),
(9, 'Vedad', 'Ibisevic', 'vedo', 'stuttgart', 2),
(10, 'Miralem', 'Pjanic', 'maliprinc', 'password', 2),
(11, 'Edin', 'Dzeko', 'jackson', 'amra', 2),
(12, 'Jasmin', 'Fejzic', 'fejza4', '12345', 2),
(13, 'Mensur', 'Mujdza', 'memu', '54321', 2),
(14, 'Administrator', 'Administrator', 'admin', 'admin', 2),
(15, 'Anonimni', 'Korisnik', 'korisnik', 'korisnik', 2),
(16, 'Ajdin', 'Kahrovic', 'a', 'a', 1);

-- --------------------------------------------------------

--
-- Table structure for table `linije`
--

CREATE TABLE IF NOT EXISTS `linije` (
  `idLinije` int(11) NOT NULL AUTO_INCREMENT,
  `brojLinije` varchar(200) COLLATE utf8_slovenian_ci NOT NULL,
  `smjer` varchar(200) COLLATE utf8_slovenian_ci NOT NULL,
  `tipVozila` int(11) NOT NULL,
  PRIMARY KEY (`idLinije`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_slovenian_ci AUTO_INCREMENT=63 ;

--
-- Dumping data for table `linije`
--

INSERT INTO `linije` (`idLinije`, `brojLinije`, `smjer`, `tipVozila`) VALUES
(11, '1', 'ZeljetnickaStanica-Bascarsija', 1),
(12, '1', 'Bascarsija-ZeljeznickaStanica', 1),
(21, '2', 'CengicVila-Bascarsija', 1),
(22, '2', 'Bascarsija-CengicVila', 1),
(31, '3', 'Ilidza-Bascarsija', 1),
(32, '3', 'Bascarsija-Ilidza', 1),
(41, '4', 'Ilidza-ZeljeznickaStanica', 1),
(42, '4', 'ZeljetnickaStanica-Ilidza', 1),
(51, '5', 'Nedzarici-Bascarsija', 1),
(52, '5', 'Bascarsija-Nedzarici', 1),
(61, '6', 'Ilidza-Skenderija', 1),
(62, '6', 'Skenderija_Ilidza', 1);

-- --------------------------------------------------------

--
-- Table structure for table `privilegije`
--

CREATE TABLE IF NOT EXISTS `privilegije` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idRole` int(11) NOT NULL,
  `idItema` int(11) NOT NULL,
  `idTabele` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idRole` (`idRole`),
  KEY `idItema` (`idItema`),
  KEY `idTabele` (`idTabele`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_slovenian_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE IF NOT EXISTS `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `naziv` varchar(50) COLLATE utf8_slovenian_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_slovenian_ci AUTO_INCREMENT=5 ;

--
-- Dumping data for table `role`
--

INSERT INTO `role` (`id`, `naziv`) VALUES
(1, 'Administrator'),
(2, 'Vozac'),
(3, 'Operater'),
(4, 'Korisnik');

-- --------------------------------------------------------

--
-- Table structure for table `stanice`
--

CREATE TABLE IF NOT EXISTS `stanice` (
  `idStanice` int(11) NOT NULL AUTO_INCREMENT,
  `naziv` varchar(100) COLLATE utf8_slovenian_ci NOT NULL,
  `lat` decimal(12,9) NOT NULL,
  `lon` decimal(12,9) NOT NULL,
  PRIMARY KEY (`idStanice`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_slovenian_ci AUTO_INCREMENT=44 ;

--
-- Dumping data for table `stanice`
--

INSERT INTO `stanice` (`idStanice`, `naziv`, `lat`, `lon`) VALUES
(1, 'ilidza', '43.830776000', '18.309105000'),
(2, 'energoinvest', '43.837642000', '18.317667000'),
(3, 'stup', '43.842667000', '18.328012000'),
(4, 'avaz', '43.844332000', '18.328012000'),
(5, 'nedzarici', '43.845231000', '18.341126000'),
(6, 'alipasinop', '43.846271000', '18.347949000'),
(7, 'RTV', '43.847241000', '18.354314000'),
(8, 'alipasinm', '43.848093000', '18.360094000'),
(9, 'otoka', '43.849223000', '18.367379000'),
(10, 'Cvila', '43.850403000', '18.374047000'),
(11, 'Dolac malta', '43.851660000', '18.379600000'),
(12, 'socijalno', '43.852708000', '18.385855000'),
(13, 'pofali', '43.854270000', '18.392948000'),
(14, 'univerzitet', '43.855477000', '18.397644000'),
(15, 'muzej', '43.855593000', '18.402048000'),
(16, 'mdvor', '43.855739000', '18.407651000'),
(17, 'skenderija', '43.856361000', '18.413542000'),
(18, 'posta', '43.856547000', '18.420166000'),
(19, 'drvenija', '43.856669000', '18.423560000'),
(20, 'lcuprija', '43.857761000', '18.428703000'),
(21, 'vijecnica', '43.858644000', '18.432722000'),
(22, 'bcarsija', '43.859976000', '18.431429000'),
(23, 'katedrala', '43.859754000', '18.425317000'),
(24, 'banka', '43.858881000', '18.420118000'),
(25, 'park', '43.858626000', '18.413617000'),
(26, 'mdvor', '43.856122000', '18.408192000'),
(27, 'muzej', '43.855655000', '18.400756000'),
(28, 'univerzitet', '43.855571000', '18.398037000'),
(29, 'pofalici', '43.854080000', '18.392130000'),
(30, 'socijalno', '43.852562000', '18.384918000'),
(31, 'dmalta', '43.851483000', '18.378460000'),
(32, 'cvila', '43.850108000', '18.372191000'),
(33, 'otoka', '43.849105000', '18.366321000'),
(34, 'alipasinm', '43.848134000', '18.359916000'),
(35, 'RTV', '43.847166000', '18.353466000'),
(36, 'alipasinop', '43.846158000', '18.346874000'),
(37, 'nedzarici', '43.845129000', '18.340085000'),
(38, 'avaz', '43.843923000', '18.333674000'),
(39, 'stup', '43.842721000', '18.327895000'),
(40, 'energoinvest', '43.837340000', '18.317109000'),
(41, 'zstanica', '43.856080000', '18.401511000'),
(42, 'zstanica', '43.859592000', '18.400259000'),
(43, 'skenderija', '43.856745000', '18.412719000');

-- --------------------------------------------------------

--
-- Table structure for table `stanice_linije`
--

CREATE TABLE IF NOT EXISTS `stanice_linije` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idStanice` int(11) NOT NULL,
  `idLinije` int(11) NOT NULL,
  `redniBroj` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idStanice` (`idStanice`),
  KEY `idLinije` (`idLinije`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_slovenian_ci AUTO_INCREMENT=173 ;

--
-- Dumping data for table `stanice_linije`
--

INSERT INTO `stanice_linije` (`id`, `idStanice`, `idLinije`, `redniBroj`) VALUES
(1, 42, 11, 1),
(2, 15, 11, 2),
(3, 16, 11, 3),
(4, 17, 11, 4),
(5, 18, 11, 5),
(6, 19, 11, 6),
(7, 20, 12, 7),
(8, 21, 12, 8),
(9, 22, 12, 9),
(10, 23, 12, 10),
(11, 24, 12, 11),
(12, 25, 12, 12),
(13, 26, 12, 13),
(14, 27, 12, 14),
(15, 41, 12, 15),
(16, 10, 21, 1),
(17, 11, 21, 2),
(18, 12, 21, 3),
(19, 13, 21, 4),
(20, 14, 21, 5),
(21, 15, 21, 6),
(22, 16, 21, 7),
(23, 17, 21, 8),
(24, 18, 21, 9),
(25, 19, 21, 10),
(26, 20, 21, 11),
(27, 21, 22, 12),
(28, 22, 22, 13),
(29, 23, 22, 14),
(30, 24, 22, 15),
(31, 25, 22, 16),
(32, 26, 22, 17),
(33, 27, 22, 18),
(34, 28, 22, 19),
(35, 29, 22, 20),
(36, 30, 22, 21),
(37, 31, 22, 22),
(38, 1, 31, 1),
(39, 2, 31, 2),
(40, 3, 31, 3),
(41, 4, 31, 4),
(42, 5, 31, 5),
(43, 6, 31, 6),
(44, 7, 31, 7),
(45, 8, 31, 8),
(46, 9, 31, 9),
(47, 10, 31, 10),
(48, 11, 31, 11),
(49, 12, 31, 12),
(50, 13, 31, 13),
(51, 14, 31, 14),
(52, 15, 31, 15),
(53, 16, 31, 16),
(54, 17, 31, 17),
(55, 18, 31, 18),
(56, 19, 31, 19),
(57, 20, 31, 20),
(58, 21, 32, 21),
(59, 22, 32, 22),
(60, 23, 32, 23),
(61, 24, 32, 24),
(62, 25, 32, 25),
(63, 26, 32, 26),
(64, 27, 32, 27),
(65, 28, 32, 28),
(66, 29, 32, 29),
(67, 30, 32, 30),
(68, 31, 32, 31),
(69, 32, 32, 32),
(70, 33, 32, 33),
(71, 34, 32, 34),
(72, 35, 32, 35),
(73, 36, 32, 36),
(74, 37, 32, 37),
(75, 38, 32, 38),
(76, 39, 32, 39),
(77, 40, 32, 40),
(78, 4, 51, 1),
(79, 5, 51, 2),
(80, 6, 51, 3),
(81, 7, 51, 4),
(82, 8, 51, 5),
(83, 9, 51, 6),
(84, 10, 51, 7),
(85, 11, 51, 8),
(86, 12, 51, 9),
(87, 13, 51, 10),
(88, 14, 51, 11),
(89, 15, 51, 12),
(90, 16, 51, 13),
(91, 17, 51, 14),
(92, 18, 51, 15),
(93, 19, 51, 16),
(94, 20, 51, 17),
(95, 21, 52, 18),
(96, 22, 52, 19),
(97, 23, 52, 20),
(98, 24, 52, 21),
(99, 25, 52, 22),
(100, 26, 52, 23),
(101, 27, 52, 24),
(102, 28, 52, 25),
(103, 29, 52, 26),
(104, 30, 52, 27),
(105, 31, 52, 28),
(106, 32, 52, 29),
(107, 33, 52, 30),
(108, 34, 52, 31),
(109, 35, 52, 32),
(110, 36, 52, 33),
(111, 37, 52, 34),
(112, 1, 41, 1),
(113, 2, 41, 2),
(114, 3, 41, 3),
(115, 4, 41, 4),
(116, 5, 41, 5),
(117, 6, 41, 6),
(118, 7, 41, 7),
(119, 8, 41, 8),
(120, 9, 41, 9),
(121, 10, 41, 10),
(122, 11, 41, 11),
(123, 12, 41, 12),
(124, 13, 41, 13),
(125, 14, 41, 14),
(126, 41, 41, 15),
(127, 42, 42, 16),
(128, 28, 42, 17),
(129, 29, 42, 18),
(130, 30, 42, 19),
(131, 31, 42, 20),
(132, 32, 42, 21),
(133, 33, 42, 22),
(134, 34, 42, 23),
(135, 35, 42, 24),
(136, 36, 42, 25),
(137, 37, 42, 26),
(138, 38, 42, 27),
(139, 39, 42, 28),
(140, 40, 42, 29),
(141, 1, 61, 1),
(142, 2, 61, 2),
(143, 3, 61, 3),
(144, 4, 61, 4),
(145, 5, 61, 5),
(146, 6, 61, 6),
(147, 7, 61, 7),
(148, 8, 61, 8),
(149, 9, 61, 9),
(150, 10, 61, 10),
(151, 11, 61, 11),
(152, 12, 61, 12),
(153, 13, 61, 13),
(154, 14, 61, 14),
(155, 15, 61, 15),
(156, 16, 61, 16),
(157, 43, 62, 17),
(158, 26, 62, 18),
(159, 27, 62, 19),
(160, 28, 62, 20),
(161, 29, 62, 21),
(162, 30, 62, 22),
(163, 31, 62, 23),
(164, 32, 62, 24),
(165, 33, 62, 25),
(166, 34, 62, 26),
(167, 35, 62, 27),
(168, 36, 62, 28),
(169, 37, 62, 29),
(170, 38, 62, 30),
(171, 39, 62, 31),
(172, 40, 62, 32);

-- --------------------------------------------------------

--
-- Table structure for table `tabele`
--

CREATE TABLE IF NOT EXISTS `tabele` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `naziv` varchar(100) COLLATE utf8_slovenian_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_slovenian_ci AUTO_INCREMENT=12 ;

--
-- Dumping data for table `tabele`
--

INSERT INTO `tabele` (`id`, `naziv`) VALUES
(1, 'korisnici'),
(2, 'linije'),
(3, 'itemi'),
(4, 'privilegije'),
(5, 'role'),
(6, 'stanice'),
(7, 'stanice_linije'),
(8, 'tabele'),
(9, 'tipovivozila'),
(10, 'vozila'),
(11, 'voznje');

-- --------------------------------------------------------

--
-- Table structure for table `tipovivozila`
--

CREATE TABLE IF NOT EXISTS `tipovivozila` (
  `idTipVozila` int(11) NOT NULL AUTO_INCREMENT,
  `naziv` varchar(100) COLLATE utf8_slovenian_ci NOT NULL,
  PRIMARY KEY (`idTipVozila`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_slovenian_ci AUTO_INCREMENT=5 ;

--
-- Dumping data for table `tipovivozila`
--

INSERT INTO `tipovivozila` (`idTipVozila`, `naziv`) VALUES
(1, 'tramvaj'),
(2, 'trolejbus'),
(3, 'autobus'),
(4, 'minibus');

-- --------------------------------------------------------

--
-- Table structure for table `vozila`
--

CREATE TABLE IF NOT EXISTS `vozila` (
  `brojVozila` int(11) NOT NULL,
  `tipVozila` int(11) NOT NULL,
  PRIMARY KEY (`brojVozila`),
  KEY `tipVozila` (`tipVozila`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_slovenian_ci;

--
-- Dumping data for table `vozila`
--

INSERT INTO `vozila` (`brojVozila`, `tipVozila`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(11, 2),
(12, 2),
(13, 2),
(14, 2),
(15, 2),
(16, 2),
(17, 2),
(18, 2),
(19, 2),
(20, 2),
(21, 3),
(22, 3),
(23, 3),
(24, 3),
(25, 3),
(26, 3),
(27, 3),
(28, 3),
(29, 3),
(30, 3),
(31, 4),
(32, 4),
(33, 4),
(34, 4),
(35, 4),
(36, 4),
(37, 4),
(38, 4),
(39, 4),
(40, 4);

-- --------------------------------------------------------

--
-- Table structure for table `voznje`
--

CREATE TABLE IF NOT EXISTS `voznje` (
  `idVoznje` int(11) NOT NULL AUTO_INCREMENT,
  `idVozila` int(11) NOT NULL,
  `idStanice` int(11) NOT NULL,
  `idKorisnika` int(11) NOT NULL,
  `idLinije` int(11) NOT NULL,
  `lat` decimal(12,9) NOT NULL,
  `lon` decimal(12,9) NOT NULL,
  `aktivan` tinyint(1) NOT NULL,
  PRIMARY KEY (`idVoznje`),
  KEY `idVozila` (`idVozila`),
  KEY `idKorisnika` (`idKorisnika`),
  KEY `idStanice` (`idStanice`),
  KEY `idLinije` (`idLinije`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_slovenian_ci AUTO_INCREMENT=6 ;

--
-- Dumping data for table `voznje`
--

INSERT INTO `voznje` (`idVoznje`, `idVozila`, `idStanice`, `idKorisnika`, `idLinije`, `lat`, `lon`, `aktivan`) VALUES
(1, 1, 17, 2, 51, '43.856477000', '18.416436000', 1),
(2, 2, 27, 10, 42, '43.855511000', '18.397224000', 1),
(3, 3, 35, 11, 32, '43.846508000', '18.349205000', 1),
(4, 4, 19, 6, 31, '43.856926000', '18.425753000', 1),
(5, 5, 23, 1, 12, '43.859324000', '18.423663000', 1);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `korisnici`
--
ALTER TABLE `korisnici`
  ADD CONSTRAINT `korisnici_ibfk_1` FOREIGN KEY (`idRole`) REFERENCES `role` (`id`);

--
-- Constraints for table `privilegije`
--
ALTER TABLE `privilegije`
  ADD CONSTRAINT `privilegije_ibfk_1` FOREIGN KEY (`idRole`) REFERENCES `role` (`id`),
  ADD CONSTRAINT `privilegije_ibfk_2` FOREIGN KEY (`idItema`) REFERENCES `itemi` (`id`),
  ADD CONSTRAINT `privilegije_ibfk_3` FOREIGN KEY (`idTabele`) REFERENCES `tabele` (`id`);

--
-- Constraints for table `stanice_linije`
--
ALTER TABLE `stanice_linije`
  ADD CONSTRAINT `stanice_linije_ibfk_1` FOREIGN KEY (`idStanice`) REFERENCES `stanice` (`idStanice`),
  ADD CONSTRAINT `stanice_linije_ibfk_2` FOREIGN KEY (`idLinije`) REFERENCES `linije` (`idLinije`);

--
-- Constraints for table `vozila`
--
ALTER TABLE `vozila`
  ADD CONSTRAINT `vozila_ibfk_1` FOREIGN KEY (`tipVozila`) REFERENCES `tipovivozila` (`idTipVozila`);

--
-- Constraints for table `voznje`
--
ALTER TABLE `voznje`
  ADD CONSTRAINT `voznje_ibfk_1` FOREIGN KEY (`idVozila`) REFERENCES `vozila` (`brojVozila`),
  ADD CONSTRAINT `voznje_ibfk_2` FOREIGN KEY (`idStanice`) REFERENCES `stanice` (`idStanice`),
  ADD CONSTRAINT `voznje_ibfk_3` FOREIGN KEY (`idLinije`) REFERENCES `linije` (`idLinije`),
  ADD CONSTRAINT `voznje_ibfk_4` FOREIGN KEY (`idKorisnika`) REFERENCES `korisnici` (`idKorisnika`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
