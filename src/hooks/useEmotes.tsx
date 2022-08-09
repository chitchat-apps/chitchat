import { useContext } from "react";
import { EmoteContext } from "../context/emotesContext";

const useEmotes = () => {
  const emoteContext = useContext(EmoteContext);
  if (!emoteContext) throw new Error("BadgeContext not found");
  return emoteContext;
};

export default useEmotes;
