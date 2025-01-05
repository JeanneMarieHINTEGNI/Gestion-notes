import { supabase } from "../lib/supabase";

export const getNotes = async () => {
  const { data, error } = await supabase.from("notes").select("*");
  if (error) throw error;
  return data;
};
