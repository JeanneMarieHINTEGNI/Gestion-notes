export type Database = {
    public: {
      Tables: {
        etudiants: {
          Row: { id: string; nom: string; prenom: string; matricule: string };
          Insert: { id?: string; nom: string; prenom: string; matricule: string };
          Update: Partial<{ nom: string; prenom: string; matricule: string }>;
        };
        // Ajoutez d'autres tables ici
      };
    };
  };
  