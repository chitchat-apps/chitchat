import { useContext } from "react";
import { TabContext } from "../context/tabContext";

const useTabs = () => {
  const tabsContext = useContext(TabContext);

  return tabsContext!;
};

export default useTabs;
