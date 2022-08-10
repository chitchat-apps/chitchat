import { useContext } from "react";
import { StreamsContext } from "../context/streamsContext";

const useStreams = () => {
  const streamsContext = useContext(StreamsContext);
  if (!streamsContext) throw new Error("StreamContext not found");
  return streamsContext;
};

export default useStreams;
