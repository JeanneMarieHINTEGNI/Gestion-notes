import { supabase } from "../lib/supabase";

export const getECs = async () => {
  const { data, error } = await supabase.from("ecs").select("*");
  if (error) throw error;
  return data;
};
