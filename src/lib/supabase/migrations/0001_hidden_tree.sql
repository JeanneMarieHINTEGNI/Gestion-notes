/*
  # Création des tables pour le système de gestion des notes LMD

  1. Nouvelles Tables
    - `unites_enseignement`: Stockage des UEs
      - `id` (uuid, clé primaire)
      - `code` (text, unique, format UExx)
      - `nom` (text)
      - `credits_ects` (integer, 1-30)
      - `semestre` (integer, 1-6)
      - Horodatage

    - `elements_constitutifs`: Stockage des ECs
      - `id` (uuid, clé primaire)
      - `code` (text)
      - `nom` (text)
      - `coefficient` (integer, 1-5)
      - `ue_id` (référence vers unites_enseignement)
      - Horodatage

    - `etudiants`: Stockage des étudiants
      - `id` (uuid, clé primaire)
      - `numero_etudiant` (text, unique)
      - `nom` (text)
      - `prenom` (text)
      - `niveau` (enum: L1, L2, L3)
      - Horodatage

    - `notes`: Stockage des notes
      - `id` (uuid, clé primaire)
      - `etudiant_id` (référence vers etudiants)
      - `ec_id` (référence vers elements_constitutifs)
      - `note` (numeric, 0-20)
      - `session` (enum: normale, rattrapage)
      - `date_evaluation` (timestamp)
      - Horodatage

  2. Sécurité
    - RLS activé sur toutes les tables
    - Politiques de lecture/écriture pour les utilisateurs authentifiés
*/

-- Création des types énumérés
CREATE TYPE niveau_etudiant AS ENUM ('L1', 'L2', 'L3');
CREATE TYPE session_type AS ENUM ('normale', 'rattrapage');

-- Table des unités d'enseignement
CREATE TABLE IF NOT EXISTS unites_enseignement (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL CHECK (code ~ '^UE[0-9]{2}$'),
    nom text NOT NULL,
    credits_ects integer NOT NULL CHECK (credits_ects BETWEEN 1 AND 30),
    semestre integer NOT NULL CHECK (semestre BETWEEN 1 AND 6),
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    UNIQUE(code)
);

-- Table des éléments constitutifs
CREATE TABLE IF NOT EXISTS elements_constitutifs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL,
    nom text NOT NULL,
    coefficient integer NOT NULL CHECK (coefficient BETWEEN 1 AND 5),
    ue_id uuid NOT NULL REFERENCES unites_enseignement(id) ON DELETE CASCADE,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Table des étudiants
CREATE TABLE IF NOT EXISTS etudiants (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    numero_etudiant text NOT NULL,
    nom text NOT NULL,
    prenom text NOT NULL,
    niveau niveau_etudiant NOT NULL,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    UNIQUE(numero_etudiant)
);

-- Table des notes
CREATE TABLE IF NOT EXISTS notes (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    etudiant_id uuid NOT NULL REFERENCES etudiants(id) ON DELETE CASCADE,
    ec_id uuid NOT NULL REFERENCES elements_constitutifs(id) ON DELETE CASCADE,
    note numeric(4,2) NOT NULL CHECK (note BETWEEN 0 AND 20),
    session session_type NOT NULL,
    date_evaluation timestamptz NOT NULL,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    UNIQUE(etudiant_id, ec_id, session)
);

-- Activation de RLS
ALTER TABLE unites_enseignement ENABLE ROW LEVEL SECURITY;
ALTER TABLE elements_constitutifs ENABLE ROW LEVEL SECURITY;
ALTER TABLE etudiants ENABLE ROW LEVEL SECURITY;
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;

-- Politiques de sécurité pour les utilisateurs authentifiés
CREATE POLICY "Utilisateurs authentifiés peuvent lire les UEs"
    ON unites_enseignement FOR SELECT TO authenticated USING (true);

CREATE POLICY "Utilisateurs authentifiés peuvent modifier les UEs"
    ON unites_enseignement FOR ALL TO authenticated USING (true);

CREATE POLICY "Utilisateurs authentifiés peuvent lire les ECs"
    ON elements_constitutifs FOR SELECT TO authenticated USING (true);

CREATE POLICY "Utilisateurs authentifiés peuvent modifier les ECs"
    ON elements_constitutifs FOR ALL TO authenticated USING (true);

CREATE POLICY "Utilisateurs authentifiés peuvent lire les étudiants"
    ON etudiants FOR SELECT TO authenticated USING (true);

CREATE POLICY "Utilisateurs authentifiés peuvent modifier les étudiants"
    ON etudiants FOR ALL TO authenticated USING (true);

CREATE POLICY "Utilisateurs authentifiés peuvent lire les notes"
    ON notes FOR SELECT TO authenticated USING (true);

CREATE POLICY "Utilisateurs authentifiés peuvent modifier les notes"
    ON notes FOR ALL TO authenticated USING (true);

-- Triggers pour mise à jour automatique de updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_unites_enseignement_updated_at
    BEFORE UPDATE ON unites_enseignement
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_elements_constitutifs_updated_at
    BEFORE UPDATE ON elements_constitutifs
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_etudiants_updated_at
    BEFORE UPDATE ON etudiants
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_notes_updated_at
    BEFORE UPDATE ON notes
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();