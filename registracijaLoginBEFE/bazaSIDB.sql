SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`table1`
-- -----------------------------------------------------



-- -----------------------------------------------------
-- Table `mydb`.`Kurs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Kurs` (
  `KursId` INT NOT NULL AUTO_INCREMENT,
  `NazivKursa` VARCHAR(45) NOT NULL,
  `Odsjek` VARCHAR(45) NULL,
  `Semestar` VARCHAR(45) NULL,
  `Smjer` VARCHAR(45) NULL,
  `Ciklus` VARCHAR(45) NULL,
  PRIMARY KEY (`KursId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Ispit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Ispit` (
  `IspitId` INT NOT NULL AUTO_INCREMENT,
  `DatumIspita` DATETIME NOT NULL,
  `BrojParcijale` INT NULL,
  `NazivKabineta` VARCHAR(45) NOT NULL,
  `Kurs_KursId` INT NOT NULL,
  PRIMARY KEY (`IspitId`, `Kurs_KursId`),
  INDEX `fk_Ispit_Kurs1_idx` (`Kurs_KursId` ASC),
  CONSTRAINT `fk_Ispit_Kurs1`
    FOREIGN KEY (`Kurs_KursId`)
    REFERENCES `mydb`.`Kurs` (`KursId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`RezultatiZadatka`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`RezultatiZadatka` (
  `RezultatId` INT NOT NULL AUTO_INCREMENT,
  `OsvojeniBrojBodova` INT NULL,
  PRIMARY KEY (`RezultatId`),
  UNIQUE INDEX `OsvojeniBrojBodova_UNIQUE` (`OsvojeniBrojBodova` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Zadatak`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Zadatak` (
  `ZadatakId` INT NOT NULL AUTO_INCREMENT,
  `RedniBrojZadatka` INT NOT NULL,
  `MaxBrojBodova` INT NOT NULL,
  `Komentar` VARCHAR(45) NULL,
  `Ispit_IspitId` INT NOT NULL,
  `Ispit_Kurs_KursId` INT NOT NULL,
  `RezultatiZadatka_RezultatId` INT NOT NULL,
  PRIMARY KEY (`ZadatakId`, `Ispit_IspitId`, `Ispit_Kurs_KursId`, `RezultatiZadatka_RezultatId`),
  INDEX `fk_Zadatak_Ispit1_idx` (`Ispit_IspitId` ASC, `Ispit_Kurs_KursId` ASC),
  INDEX `fk_Zadatak_RezultatiZadatka1_idx` (`RezultatiZadatka_RezultatId` ASC),
  CONSTRAINT `fk_Zadatak_Ispit1`
    FOREIGN KEY (`Ispit_IspitId` , `Ispit_Kurs_KursId`)
    REFERENCES `mydb`.`Ispit` (`IspitId` , `Kurs_KursId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Zadatak_RezultatiZadatka1`
    FOREIGN KEY (`RezultatiZadatka_RezultatId`)
    REFERENCES `mydb`.`RezultatiZadatka` (`RezultatId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`KorisnickiDetalji`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`KorisnickiDetalji` (
  `KorisnickiDetaljiId` INT NOT NULL AUTO_INCREMENT,
  `Ime` VARCHAR(45) NULL,
  `Prezime` VARCHAR(45) NULL,
  `BrojIndexa` VARCHAR(45) NULL,
  `DatumRodjenja` DATE NULL,
  `Email` VARCHAR(45) NULL,
  PRIMARY KEY (`KorisnickiDetaljiId`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC),
  UNIQUE INDEX `BrojIndexa_UNIQUE` (`BrojIndexa` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Odsjek`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Odsjek` (
  `OdsjekId` INT NOT NULL AUTO_INCREMENT,
  `KorisnickiDetalji_KorisnickiDetaljiId` INT NOT NULL,
  `Naziv` VARCHAR(45) NULL,
  `Smjer` VARCHAR(45) NULL,
  `Fakultet` VARCHAR(45) NULL,
  PRIMARY KEY (`OdsjekId`, `KorisnickiDetalji_KorisnickiDetaljiId`),
  INDEX `fk_Smjer_KorisnickiDetalji1_idx` (`KorisnickiDetalji_KorisnickiDetaljiId` ASC),
  CONSTRAINT `fk_Smjer_KorisnickiDetalji1`
    FOREIGN KEY (`KorisnickiDetalji_KorisnickiDetaljiId`)
    REFERENCES `mydb`.`KorisnickiDetalji` (`KorisnickiDetaljiId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TipKorisnika`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TipKorisnika` (
  `TipKorisnikaId` INT NOT NULL AUTO_INCREMENT,
  `Tip` VARCHAR(45) NULL,
  `KorisnickiDetalji_KorisnickiDetaljiId` INT NOT NULL,
  PRIMARY KEY (`TipKorisnikaId`, `KorisnickiDetalji_KorisnickiDetaljiId`),
  UNIQUE INDEX `TipKorisnikaId_UNIQUE` (`TipKorisnikaId` ASC),
  INDEX `fk_TipKorisnika_KorisnickiDetalji1_idx` (`KorisnickiDetalji_KorisnickiDetaljiId` ASC),
  CONSTRAINT `fk_TipKorisnika_KorisnickiDetalji1`
    FOREIGN KEY (`KorisnickiDetalji_KorisnickiDetaljiId`)
    REFERENCES `mydb`.`KorisnickiDetalji` (`KorisnickiDetaljiId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Korisnik`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Korisnik` (
  `KorisnikId` INT NOT NULL AUTO_INCREMENT,
  `TipKorisnika_TipKorisnikaId` INT NOT NULL,
  `Username` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(45) NOT NULL,
  `Aktivan` BIT NULL,
  `DatumKreiranjaAccounta` DATE NULL,
  `DatumVazenjaAccounta` DATE NULL,
  PRIMARY KEY (`KorisnikId`, `TipKorisnika_TipKorisnikaId`),
  UNIQUE INDEX `KorisnikId_UNIQUE` (`KorisnikId` ASC),
  UNIQUE INDEX `Username_UNIQUE` (`Username` ASC),
  INDEX `fk_Korisnik_TipKorisnika1_idx` (`TipKorisnika_TipKorisnikaId` ASC),
  CONSTRAINT `fk_Korisnik_TipKorisnika1`
    FOREIGN KEY (`TipKorisnika_TipKorisnikaId`)
    REFERENCES `mydb`.`TipKorisnika` (`TipKorisnikaId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Korisnik_Kurs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Korisnik_Kurs` (
  `Korisnik_KorisnikId` INT NOT NULL,
  `Korisnik_TipKorisnika_TipKorisnikaId` INT NOT NULL,
  `Kurs_KursId` INT NOT NULL,
  PRIMARY KEY (`Korisnik_KorisnikId`, `Korisnik_TipKorisnika_TipKorisnikaId`, `Kurs_KursId`),
  INDEX `fk_Korisnik_has_Kurs_Kurs1_idx` (`Kurs_KursId` ASC),
  INDEX `fk_Korisnik_has_Kurs_Korisnik1_idx` (`Korisnik_KorisnikId` ASC, `Korisnik_TipKorisnika_TipKorisnikaId` ASC),
  CONSTRAINT `fk_Korisnik_has_Kurs_Korisnik1`
    FOREIGN KEY (`Korisnik_KorisnikId` , `Korisnik_TipKorisnika_TipKorisnikaId`)
    REFERENCES `mydb`.`Korisnik` (`KorisnikId` , `TipKorisnika_TipKorisnikaId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Korisnik_has_Kurs_Kurs1`
    FOREIGN KEY (`Kurs_KursId`)
    REFERENCES `mydb`.`Kurs` (`KursId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;