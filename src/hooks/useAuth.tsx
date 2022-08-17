import { useContext } from "react";
import { AuthContext } from "../context/authContext";

const useAuth = () => {
  const authContext = useContext(AuthContext);
  if (!authContext) throw new Error("AuthContext not found");
  return authContext;
};

export default useAuth;
