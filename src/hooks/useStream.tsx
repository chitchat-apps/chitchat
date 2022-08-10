import { useContext } from "react";
import { StreamsContext } from "../context/streamsContext";

const useStream = (stream: string) => {
  const streamsContext = useContext(StreamsContext);
  if (!streamsContext) throw new Error("StreamContext not found");

  return streamsContext.streams.find((s) => s.username === stream);
};

export default useStream;
