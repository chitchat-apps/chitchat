import { useQuery } from "@tanstack/react-query";
import { createContext, FC, ReactNode, useState } from "react";

export interface IAuthContext {
  isLoading: boolean;
  isAuthenticated: boolean | null;
  username: string | null;
  token: string | null;
  verifyToken: (newToken?: string) => Promise<boolean>;
  login: (token: string, username: string) => void;
  logout: () => void;
}

export const AuthContext = createContext<IAuthContext | null>(null);

const AuthProvider: FC<{
  children: ReactNode;
}> = ({ children }) => {
  const [token, setToken] = useState<string | null>(
    localStorage.getItem("token")
  );
  const [isLoading, setIsLoading] = useState<boolean>(!!token);
  const [username, setUsername] = useState<string | null>(null);
  const [isAuthenticated, setIsAuthenticated] = useState<boolean>(false);

  useQuery(["verifyToken", token], () => verifyToken(token ?? undefined), {
    staleTime: 0,
    refetchInterval: 1000 * 60 * 60, // 60 minutes
    refetchOnMount: false,
    refetchOnWindowFocus: false,
    onSettled: () => setIsLoading(false),
  });

  const verifyToken = async (newToken?: string) => {
    setIsLoading(true);
    try {
      const t = newToken || token;
      const res = await fetch("https://id.twitch.tv/oauth2/validate", {
        headers: {
          Authorization: `Bearer ${t}`,
        },
      });
      if (!res.ok) throw new Error("Invalid token");
      const data = await res.json();
      login(t!, data.login);
      return true;
    } catch (error) {
      logout();
      return false;
    } finally {
      setIsLoading(false);
    }
  };

  const logout = () => {
    setIsAuthenticated(false);
    setToken(null);
    setUsername(null);
    localStorage.removeItem("token");
    localStorage.removeItem("username");
  };

  const login = (token: string, username: string) => {
    setToken(token);
    setUsername(username);
    setIsAuthenticated(true);
    localStorage.setItem("token", token);
    localStorage.setItem("username", username);
  };

  return (
    <AuthContext.Provider
      value={{
        isLoading,
        isAuthenticated,
        username,
        token,
        verifyToken,
        login,
        logout,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export default AuthProvider;
