import { useQuery } from "@tanstack/react-query";
import { createContext, FC, ReactNode } from "react";
import { BttvEmote, getBttvGlobalEmotes } from "../api/bttv";

export interface IEmoteContext {
  isLoading: boolean;
  bttvEmotes: BttvEmote[];
}

export const EmoteContext = createContext<IEmoteContext | null>(null);

const EmoteProvider: FC<{
  children: ReactNode;
  initialGlobalBttvEmotes?: BttvEmote[];
}> = ({ children, initialGlobalBttvEmotes = [] }) => {
  const globalEmotesQuery = useQuery(
    ["bttvGlobalEmotes"],
    getBttvGlobalEmotes,
    {
      initialData: initialGlobalBttvEmotes,
      refetchInterval: 1000 * 60 * 10, // 10 minutes
    }
  );

  return (
    <EmoteContext.Provider
      value={{
        bttvEmotes: globalEmotesQuery.data,
        isLoading: globalEmotesQuery.isLoading,
      }}
    >
      {children}
    </EmoteContext.Provider>
  );
};

export default EmoteProvider;
