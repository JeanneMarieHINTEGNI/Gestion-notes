// Types pour la base de données
export interface UniteEnseignement {
    id: string;
    code: string;
    nom: string;
    credits_ects: number;
    semestre: number;
    created_at: Date;
    updated_at: Date;
  }
  
  export interface ElementConstitutif {
    id: string;
    code: string;
    nom: string;
    coefficient: number;
    ue_id: string;
    created_at: Date;
    updated_at: Date;
  }
  
  export interface Etudiant {
    id: string;
    numero_etudiant: string;
    nom: string;
    prenom: string;
    niveau: 'L1' | 'L2' | 'L3';
    created_at: Date;
    updated_at: Date;
  }
  
  export interface Note {
    id: string;
    etudiant_id: string;
    ec_id: string;
    note: number;
    session: 'normale' | 'rattrapage';
    date_evaluation: Date;
    created_at: Date;
    updated_at: Date;
  }
  
  // Types pour les formulaires
  export interface UEFormData {
    code: string;
    nom: string;
    credits_ects: number;
    semestre: number;
  }
  
  export interface ECFormData {
    code: string;
    nom: string;
    coefficient: number;
    ue_id: string;
  }
  
  export interface NoteFormData {
    etudiant_id: string;
    ec_id: string;
    note: number;
    session: 'normale' | 'rattrapage';
    date_evaluation: Date;
  }