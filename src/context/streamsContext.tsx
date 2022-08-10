import { useQuery } from "@tanstack/react-query";
import { createContext, FC, ReactNode, useEffect, useState } from "react";
import { getStreams, Stream } from "../api/chitchat";
import useChats from "../hooks/useChats";

export interface IChannelContext {
  isLoading: boolean;
  streams: Stream[];
  addStream: (stream: string) => void;
  removeStream: (stream: string) => void;
}

export const StreamsContext = createContext<IChannelContext | null>(null);

const StreamsProvider: FC<{
  children: ReactNode;
  initialStreams?: string[];
}> = ({ children, initialStreams = [] }) => {
  const { channels } = useChats();

  const [streams, setStreams] = useState<string[]>(initialStreams);

  const streamsQuery = useQuery(
    ["streams", ...streams],
    () => getStreams(streams),
    {
      refetchInterval: 1000 * 60 * 2, // 2 minutes
      enabled: streams.length > 0,
    }
  );

  useEffect(() => {
    setStreams([...channels]);
  }, [channels]);

  const addStream = (stream: string) => setStreams([...streams, stream]);
  const removeStream = (stream: string) =>
    setStreams(streams.filter((s) => s !== stream));

  return (
    <StreamsContext.Provider
      value={{
        isLoading: streamsQuery.isLoading,
        streams: streamsQuery.data || [],
        addStream,
        removeStream,
      }}
    >
      {children}
    </StreamsContext.Provider>
  );
};

export default StreamsProvider;
