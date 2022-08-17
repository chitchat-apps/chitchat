import {
  createContext,
  FC,
  ReactNode,
  useEffect,
  useMemo,
  useState,
} from "react";
import { Client, Options } from "tmi.js";
import useAuth from "../hooks/useAuth";
import { ChannelTab, Tab } from "../lib/tab";

type Status = "CONNECTING" | "CONNECTED" | "DISCONNECTED";

export interface ITmiClientContext {
  client: Client;
  status: Status;
}

export const TmiClientContext = createContext<ITmiClientContext | null>(null);

export const getChannelsFromLs = () => {
  const initialChannels: string[] = [];
  const tabs = localStorage.getItem("tabs");
  if (tabs) {
    const tabList = JSON.parse(tabs) as Tab[];
    tabList.forEach(
      (tab) =>
        "channel" in tab && initialChannels.push((tab as ChannelTab).channel)
    );
  }
  return initialChannels;
};

const defaultOptions: Options = {
  channels: getChannelsFromLs(),
  connection: {
    reconnect: true,
  },
  options: {
    skipUpdatingEmotesets: true,
  },
  logger: {
    info: () => {
      /* suppress tmi.js info logs */
    },
    warn: console.warn,
    error: console.error,
  },
};

let _client = new Client(defaultOptions);

const TmiClientProvider: FC<{
  children: ReactNode;
}> = ({ children }) => {
  const auth = useAuth();
  const [status, setStatus] = useState<Status>("CONNECTING");
  const [index, setIndex] = useState(0);

  const client = useMemo(() => {
    return _client;
  }, [index]);

  useEffect(() => {
    const identity =
      auth.isAuthenticated && auth.token && auth.username
        ? {
            username: auth.username,
            password: `oauth:${auth.token}`,
          }
        : undefined;

    const channels = getChannelsFromLs();

    _client = new Client({
      channels,
      ...defaultOptions,
      identity,
    });
    setIndex((i) => i + 1);
  }, [auth.isAuthenticated, auth.token, auth.username]);

  // Listen for connection events
  useEffect(() => {
    const onConnecting = () => setStatus("CONNECTING");
    const onConnected = () => setStatus("CONNECTED");
    const onDisconnected = () => setStatus("DISCONNECTED");

    client.on("connected", onConnected);
    client.on("connecting", onConnecting);
    client.on("disconnected", onDisconnected);

    return () => {
      client.removeListener("connected", onConnected);
      client.removeListener("connecting", onConnecting);
      client.removeListener("disconnected", onDisconnected);
    };
  }, [index]);

  useEffect(() => {
    client
      .disconnect()
      .catch(console.log)
      .finally(() => {
        client.connect().catch(console.log);
      });
    return () => {
      client.disconnect().catch(console.log);
    };
  }, [index]);

  return (
    <TmiClientContext.Provider
      value={{
        client,
        status,
      }}
    >
      {children}
    </TmiClientContext.Provider>
  );
};

export default TmiClientProvider;
