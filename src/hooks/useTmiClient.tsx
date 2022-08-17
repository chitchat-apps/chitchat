import { useContext } from "react";
import { TmiClientContext } from "../context/tmiClientContext";

const useTmiClient = () => {
  const tmiClientContext = useContext(TmiClientContext);
  if (!tmiClientContext) throw new Error("TmiClientContext not found");
  return tmiClientContext;
};

export default useTmiClient;
