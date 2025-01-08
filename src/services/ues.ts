import { supabase } from "../lib/database";

export const getUEs = async () => {
  const { data, error } = await supabase.from("ues").select("*");
  if (error) throw error;
  return data;
};
