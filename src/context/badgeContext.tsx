import { useQuery } from "@tanstack/react-query";
import { createContext, FC, ReactNode } from "react";
import { BadgeSet, getGlobalBadges } from "../api/twitch";

export interface IBadgeContext {
  isLoading: boolean;
  badges: { [badge: string]: BadgeSet };
}

export const BadgeContext = createContext<IBadgeContext | null>(null);

const BadgeProvider: FC<{
  children: ReactNode;
  initialBadges?: { [badge: string]: BadgeSet };
}> = ({ children, initialBadges }) => {
  const globalQuery = useQuery(["globalBadges"], getGlobalBadges, {
    initialData: initialBadges || {},
    refetchOnWindowFocus: false,
  });

  return (
    <BadgeContext.Provider
      value={{
        badges: { ...globalQuery.data },
        isLoading: globalQuery.isLoading,
      }}
    >
      {children}
    </BadgeContext.Provider>
  );
};

export default BadgeProvider;
