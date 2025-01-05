import { supabase } from "../lib/supabase";

export const getEtudiants = async () => {
  const { data, error } = await supabase.from("etudiants").select("*");
  if (error) throw error;
  return data;
};

export const addEtudiant = async (etudiant: { nom: string; prenom: string; matricule: string }) => {
  const { data, error } = await supabase.from("etudiants").insert([etudiant]);
  if (error) throw error;
  return data;
};