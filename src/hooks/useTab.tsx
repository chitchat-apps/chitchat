import { useParams, useLocation } from "react-router-dom";
import useTabs from "./useTabs";

/**
 * Returns the current tab or undefined using the react-router context.
 * @param paramName The name of the param to search for in the react-router context. Defaults to 'id'.
 * @param baseUrl The base for the tabs. Defaults to '/home/'.
 */
const useTab = (paramName = "id", baseUrl = "/home/") => {
  const location = useLocation();
  const params = useParams();
  const { tabs } = useTabs();

  if (!location.pathname.startsWith(baseUrl)) return undefined;
  return tabs.find((t) => t.id === params[paramName]);
};

export default useTab;
