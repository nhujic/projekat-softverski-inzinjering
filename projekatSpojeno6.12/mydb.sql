-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 11, 2017 at 12:19 PM
-- Server version: 5.7.14
-- PHP Version: 5.6.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mydb`

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;
--

-- --------------------------------------------------------

--
-- Table structure for table `ispit`
--

CREATE TABLE `ispit` (
  `IspitId` int(11) NOT NULL,
  `DatumIspita` datetime NOT NULL,
  `BrojParcijale` int(11) DEFAULT NULL,
  `NazivKabineta` varchar(45) NOT NULL,
  `Kurs_KursId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `korisnickidetalji`
--

CREATE TABLE `korisnickidetalji` (
  `KorisnickiDetaljiId` int(11) NOT NULL,
  `Ime` varchar(45) DEFAULT NULL,
  `Prezime` varchar(45) DEFAULT NULL,
  `BrojIndexa` varchar(45) DEFAULT NULL,
  `DatumRodjenja` date DEFAULT NULL,
  `Email` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--

-- Table structure for table `korisnik`
--

CREATE TABLE `korisnik` (
  `KorisnikId` int(11) NOT NULL,
  `TipKorisnika_TipKorisnikaId` int(11) NOT NULL,
  `Username` varchar(45) NOT NULL,
  `Password` varchar(45) NOT NULL,
  `Aktivan` bit(1) DEFAULT NULL,
  `DatumKreiranjaAccounta` date DEFAULT NULL,
  `DatumVazenjaAccounta` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
--
-- Table structure for table `korisnik_kurs`
--

CREATE TABLE `korisnik_kurs` (
  `Korisnik_KorisnikId` int(11) NOT NULL,
  `Korisnik_TipKorisnika_TipKorisnikaId` int(11) NOT NULL,
  `Kurs_KursId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `kurs`
--

CREATE TABLE `kurs` (
  `KursId` int(11) NOT NULL,
  `NazivKursa` varchar(45) NOT NULL,
  `Odsjek` varchar(45) DEFAULT NULL,
  `Semestar` varchar(45) DEFAULT NULL,
  `Smjer` varchar(45) DEFAULT NULL,
  `Ciklus` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `odsjek`
--

CREATE TABLE `odsjek` (
  `OdsjekId` int(11) NOT NULL,
  `KorisnickiDetalji_KorisnickiDetaljiId` int(11) NOT NULL,
  `Naziv` varchar(45) DEFAULT NULL,
  `Smjer` varchar(45) DEFAULT NULL,
  `Fakultet` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `rezultatizadatka`
--

CREATE TABLE `rezultatizadatka` (
  `RezultatId` int(11) NOT NULL,
  `OsvojeniBrojBodova` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tipkorisnika`
--

CREATE TABLE `tipkorisnika` (
  `TipKorisnikaId` int(11) NOT NULL,
  `Tip` varchar(45) DEFAULT NULL,
  `KorisnickiDetalji_KorisnickiDetaljiId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `zadatak`
--

CREATE TABLE `zadatak` (
  `ZadatakId` int(11) NOT NULL,
  `RedniBrojZadatka` int(11) NOT NULL,
  `MaxBrojBodova` int(11) NOT NULL,
  `Komentar` varchar(45) DEFAULT NULL,
  `Ispit_IspitId` int(11) NOT NULL,
  `Ispit_Kurs_KursId` int(11) NOT NULL,
  `RezultatiZadatka_RezultatId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ispit`
--
ALTER TABLE `ispit`
  ADD PRIMARY KEY (`IspitId`,`Kurs_KursId`),
  ADD KEY `fk_Ispit_Kurs1_idx` (`Kurs_KursId`);

--
-- Indexes for table `korisnickidetalji`
--
ALTER TABLE `korisnickidetalji`
  ADD PRIMARY KEY (`KorisnickiDetaljiId`),
  ADD UNIQUE KEY `Email_UNIQUE` (`Email`),
  ADD UNIQUE KEY `BrojIndexa_UNIQUE` (`BrojIndexa`);

--
-- Indexes for table `korisnik`
--
ALTER TABLE `korisnik`
  ADD PRIMARY KEY (`KorisnikId`,`TipKorisnika_TipKorisnikaId`),
  ADD UNIQUE KEY `KorisnikId_UNIQUE` (`KorisnikId`),
  ADD UNIQUE KEY `Username_UNIQUE` (`Username`),
  ADD KEY `fk_Korisnik_TipKorisnika1_idx` (`TipKorisnika_TipKorisnikaId`);

--
-- Indexes for table `korisnik_kurs`
--
ALTER TABLE `korisnik_kurs`
  ADD PRIMARY KEY (`Korisnik_KorisnikId`,`Korisnik_TipKorisnika_TipKorisnikaId`,`Kurs_KursId`),
  ADD KEY `fk_Korisnik_has_Kurs_Kurs1_idx` (`Kurs_KursId`),
  ADD KEY `fk_Korisnik_has_Kurs_Korisnik1_idx` (`Korisnik_KorisnikId`,`Korisnik_TipKorisnika_TipKorisnikaId`);

--
-- Indexes for table `kurs`
--
ALTER TABLE `kurs`
  ADD PRIMARY KEY (`KursId`);

--
-- Indexes for table `odsjek`
--
ALTER TABLE `odsjek`
  ADD PRIMARY KEY (`OdsjekId`,`KorisnickiDetalji_KorisnickiDetaljiId`),
  ADD KEY `fk_Smjer_KorisnickiDetalji1_idx` (`KorisnickiDetalji_KorisnickiDetaljiId`);

--
-- Indexes for table `rezultatizadatka`
--
ALTER TABLE `rezultatizadatka`
  ADD PRIMARY KEY (`RezultatId`),
  ADD UNIQUE KEY `OsvojeniBrojBodova_UNIQUE` (`OsvojeniBrojBodova`);

--
-- Indexes for table `tipkorisnika`
--
ALTER TABLE `tipkorisnika`
  ADD PRIMARY KEY (`TipKorisnikaId`,`KorisnickiDetalji_KorisnickiDetaljiId`),
  ADD UNIQUE KEY `TipKorisnikaId_UNIQUE` (`TipKorisnikaId`),
  ADD KEY `fk_TipKorisnika_KorisnickiDetalji1_idx` (`KorisnickiDetalji_KorisnickiDetaljiId`);

--
-- Indexes for table `zadatak`
--
ALTER TABLE `zadatak`
  ADD PRIMARY KEY (`ZadatakId`,`Ispit_IspitId`,`Ispit_Kurs_KursId`,`RezultatiZadatka_RezultatId`),
  ADD KEY `fk_Zadatak_Ispit1_idx` (`Ispit_IspitId`,`Ispit_Kurs_KursId`),
  ADD KEY `fk_Zadatak_RezultatiZadatka1_idx` (`RezultatiZadatka_RezultatId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ispit`
--
ALTER TABLE `ispit`
  MODIFY `IspitId` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `korisnickidetalji`
--
ALTER TABLE `korisnickidetalji`
  MODIFY `KorisnickiDetaljiId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT for table `korisnik`
--
ALTER TABLE `korisnik`
  MODIFY `KorisnikId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `kurs`
--
ALTER TABLE `kurs`
  MODIFY `KursId` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `odsjek`
--
ALTER TABLE `odsjek`
  MODIFY `OdsjekId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT for table `rezultatizadatka`
--
ALTER TABLE `rezultatizadatka`
  MODIFY `RezultatId` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tipkorisnika`
--
ALTER TABLE `tipkorisnika`
  MODIFY `TipKorisnikaId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT for table `zadatak`
--
ALTER TABLE `zadatak`
  MODIFY `ZadatakId` int(11) NOT NULL AUTO_INCREMENT;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `ispit`
--
ALTER TABLE `ispit`
  ADD CONSTRAINT `fk_Ispit_Kurs1` FOREIGN KEY (`Kurs_KursId`) REFERENCES `kurs` (`KursId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `korisnik`
--
ALTER TABLE `korisnik`
  ADD CONSTRAINT `fk_Korisnik_TipKorisnika1` FOREIGN KEY (`TipKorisnika_TipKorisnikaId`) REFERENCES `tipkorisnika` (`TipKorisnikaId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `korisnik_kurs`
--
ALTER TABLE `korisnik_kurs`
  ADD CONSTRAINT `fk_Korisnik_has_Kurs_Korisnik1` FOREIGN KEY (`Korisnik_KorisnikId`,`Korisnik_TipKorisnika_TipKorisnikaId`) REFERENCES `korisnik` (`KorisnikId`, `TipKorisnika_TipKorisnikaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Korisnik_has_Kurs_Kurs1` FOREIGN KEY (`Kurs_KursId`) REFERENCES `kurs` (`KursId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `odsjek`
--
ALTER TABLE `odsjek`
  ADD CONSTRAINT `fk_Smjer_KorisnickiDetalji1` FOREIGN KEY (`KorisnickiDetalji_KorisnickiDetaljiId`) REFERENCES `korisnickidetalji` (`KorisnickiDetaljiId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `tipkorisnika`
--
ALTER TABLE `tipkorisnika`
  ADD CONSTRAINT `fk_TipKorisnika_KorisnickiDetalji1` FOREIGN KEY (`KorisnickiDetalji_KorisnickiDetaljiId`) REFERENCES `korisnickidetalji` (`KorisnickiDetaljiId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `zadatak`
--
ALTER TABLE `zadatak`
  ADD CONSTRAINT `fk_Zadatak_Ispit1` FOREIGN KEY (`Ispit_IspitId`,`Ispit_Kurs_KursId`) REFERENCES `ispit` (`IspitId`, `Kurs_KursId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Zadatak_RezultatiZadatka1` FOREIGN KEY (`RezultatiZadatka_RezultatId`) REFERENCES `rezultatizadatka` (`RezultatId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
