## Contenu du TP

Ce TP est composé de trois parties principales :

### 1. Extension du dernier TP et Forward Engineering
- Ajout de la table **Inscription** pour gérer les inscriptions des étudiants aux enseignements. Cette table comprend l'attribut `date_inscription`.
- Ajout de la table **Note** pour stocker les notes des étudiants par enseignement.
- Génération du code SQL du schéma via **Forward Engineering**.

#### Code SQL :
```sql
CREATE TABLE IF NOT EXISTS `tp1`.`etudiant` (
  `Etudiant_ID` INT NOT NULL,
  `Nom` VARCHAR(25) NOT NULL,
  `Prenom` VARCHAR(25) NOT NULL,
  `Date_Naissance` DATE NOT NULL,
  `Adresse` VARCHAR(50) NULL DEFAULT NULL,
  `Ville` VARCHAR(25) NULL DEFAULT NULL,
  `Code_Postal` VARCHAR(9) NULL DEFAULT NULL,
  `Telephone` VARCHAR(10) NULL DEFAULT NULL,
  `Email` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`Etudiant_ID`)
) ENGINE = InnoDB;
USE `tp1`;

-- -----------------------------------------------------
-- Table `tp1`.`enseignant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1`.`enseignant` (
  `enseignant_id` INT NOT NULL,
  `departement_id` INT NOT NULL,
  `nom` VARCHAR(25) NULL DEFAULT NULL,
  `prenom` VARCHAR(25) NULL DEFAULT NULL,
  `grade` VARCHAR(25) NULL DEFAULT NULL,
  `telephone` VARCHAR(10) NULL DEFAULT NULL,
  `fax` VARCHAR(10) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`enseignant_id`),
  INDEX `departement_id` (`departement_id` ASC) VISIBLE,
  CONSTRAINT `enseignant_ibfk_1`
    FOREIGN KEY (`departement_id`)
    REFERENCES `tp1`.`departement` (`departement_id`)
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `tp1`.`salle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1`.`salle` (
  `batiment` VARCHAR(1) NOT NULL,
  `numero_salle` VARCHAR(10) NOT NULL,
  `capacité` INT NULL DEFAULT NULL,
  PRIMARY KEY (`batiment`, `numero_salle`)
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `tp1`.`reservation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1`.`reservation` (
  `Reservation_ID` INT NOT NULL,
  `batiment` VARCHAR(1) NOT NULL,
  `numero_salle` VARCHAR(10) NOT NULL,
  `enseignement_id` INT NOT NULL,
  `departement_id` INT NOT NULL,
  `enseignant_id` INT NOT NULL,
  `Date_Resa` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `Heure_Debut` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Heure_Fin` TIME NOT NULL DEFAULT '23:00:00',
  `Nombre_Heures` INT NOT NULL,
  PRIMARY KEY (`Reservation_ID`),
  INDEX `FK_Reservation_salle` (`batiment` ASC, `numero_salle` ASC) VISIBLE,
  INDEX `FK_Reservation_enseignement` (`enseignement_id` ASC, `departement_id` ASC) VISIBLE,
  INDEX `FK_Reservation_enseignant` (`enseignant_id` ASC) VISIBLE,
  CONSTRAINT `FK_Reservation_enseignant`
    FOREIGN KEY (`enseignant_id`)
    REFERENCES `tp1`.`enseignant` (`enseignant_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `FK_Reservation_enseignement`
    FOREIGN KEY (`enseignement_id`, `departement_id`)
    REFERENCES `tp1`.`enseignement` (`enseignement_id`, `departement_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `FK_Reservation_salle`
    FOREIGN KEY (`batiment`, `numero_salle`)
    REFERENCES `tp1`.`salle` (`batiment`, `numero_salle`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Placeholder table for view `tp1`.`email_etudiant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp1`.`email_etudiant` (
  `Nom` INT,
  `Prenom` INT,
  `Email` INT
);

-- -----------------------------------------------------
-- View `tp1`.`email_etudiant`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tp1`.`email_etudiant`;
USE `tp1`;
CREATE OR REPLACE ALGORITHM=UNDEFINED
  DEFINER=`root`@`localhost`
  SQL SECURITY DEFINER
  VIEW `tp1`.`email_etudiant` AS
  SELECT `tp1`.`etudiant`.`Nom` AS `Nom`,
         `tp1`.`etudiant`.`Prenom` AS `Prenom`,
         `tp1`.`etudiant`.`Email` AS `Email`
  FROM `tp1`.`etudiant`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

````
---

### 2. Gestion des utilisateurs dans MySQL
- **Création d'utilisateurs** :
```sql
CREATE USER 'nom_utilisateur'@'hôte' IDENTIFIED BY 'mot_de_passe';
```
- **Suppression d'un utilisateur** :
```sql
DROP USER 'jean'@'localhost';
```
- **Changement de mot de passe**
```sql
ALTER USER 'jean'@'localhost' IDENTIFIED BY 'nouveauMotDePasse';
```
- **Gestion des privilèges** :
```sql
GRANT ALL PRIVILEGES ON ma_base.* TO 'jean'@'localhost';
REVOKE INSERT, UPDATE ON ma_base.* FROM 'jean'@'localhost';
```
- **Création et gestion des rôles** :
```sql
CREATE ROLE 'admin_role';
GRANT ALL PRIVILEGES ON ma_base.* TO 'admin_role';
GRANT 'admin_role' TO 'jean'@'localhost';
SET DEFAULT ROLE 'admin_role' FOR 'jean'@'localhost';
```
---

### 3. Exemple de gestion des utilisateurs dans MySQL

1. Connexion en tant qu'administrateur (root) et passage en mode SQL.
2. **Création et gestion des utilisateurs** :
   - Connexion avec `khalil_u1` et création de la table `person`.
   - Connexion avec `khalil_u2`, création et insertion de données dans `t1` et `t2`.
   - Attribution et test des privilèges entre utilisateurs.
3. **Gestion des rôles** :
   - Création du rôle `r1` et attribution de privilèges.
   - Attribution du rôle `r1` à `khalil_u0` et test des droits.
4. **Consultation des utilisateurs et privilèges dans MySQL Workbench**.

---

### Remarque :
Tous ces tests et opérations peuvent être visualisés dans **MySQL Workbench** sous :
**Administration** → **User and Privileges**

---

**Fin du TP**
