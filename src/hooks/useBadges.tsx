import { useContext } from "react";
import { BadgeContext } from "../context/badgeContext";

const useBadges = () => {
  const badgeContext = useContext(BadgeContext);
  if (!badgeContext) throw new Error("BadgeContext not found");
  return badgeContext;
};

export default useBadges;
