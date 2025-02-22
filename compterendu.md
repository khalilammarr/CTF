### Mohamed Khalil Ammar et Mariem Kammoun
**Groupe RT 2/3**
**Année Universitaire : 2024/2025**

---

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

---

### 2. Gestion des utilisateurs dans MySQL
- **Création d'utilisateurs** :
CREATE USER 'nom_utilisateur'@'hôte' IDENTIFIED BY 'mot_de_passe';

- **Suppression d'un utilisateur** :
DROP USER 'jean'@'localhost';

- **Changement de mot de passe** :
ALTER USER 'jean'@'localhost' IDENTIFIED BY 'nouveauMotDePasse';

- **Gestion des privilèges** :
GRANT ALL PRIVILEGES ON ma_base.* TO 'jean'@'localhost';
REVOKE INSERT, UPDATE ON ma_base.* FROM 'jean'@'localhost';

- **Création et gestion des rôles** :
CREATE ROLE 'admin_role';
GRANT ALL PRIVILEGES ON ma_base.* TO 'admin_role';
GRANT 'admin_role' TO 'jean'@'localhost';
SET DEFAULT ROLE 'admin_role' FOR 'jean'@'localhost';

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
"""
