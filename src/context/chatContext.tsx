import { createContext, FC, ReactNode, useEffect, useState } from "react";
import { ChannelTab, Tab } from "../lib/tab";
import tmi from "tmi.js";
import useTabs from "../hooks/useTabs";
import { Chat, IChatContext, Message, Status } from "../lib/chat";

export const ChatContext = createContext<IChatContext | null>(null);

export const getInitialChannels = () => {
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

export const client = new tmi.Client({
  channels: getInitialChannels(),
  logger: {
    info: () => {
      /* suppress tmi.js info logs */
    },
    warn: console.warn,
    error: console.error,
  },
});
client.connect();

const ChatProvider: FC<{
  children: ReactNode;
}> = ({ children }) => {
  const tabs = useTabs();

  const [channels, setChannels] = useState<string[]>([]);

  const [chats, setChats] = useState<{ [key: string]: Chat }>(() => {
    const chats: { [key: string]: Chat } = {};
    tabs?.tabs.forEach((tab) => {
      if ("channel" in tab) {
        const messages = [];
        const lsMessages = localStorage.getItem(
          `${(tab as ChannelTab).channel}-messages`
        );
        if (lsMessages) {
          const m = JSON.parse(lsMessages) as Message[];
          messages.push(...m);
        }

        chats[(tab as ChannelTab).channel] = {
          messages,
          status: "connected",
        };
      }
    });
    setChannels(Object.keys(chats));
    return chats;
  });
  const [status, setStatus] = useState<Status>("disconnected");

  useEffect(() => {
    let ignore = false;
    const onConnect = () => {
      setStatus("connected");
    };
    const onDisconnected = () => {
      setStatus("disconnected");
    };
    const onConnecting = () => {
      setStatus("connecting");
    };
    const onMessage = (
      channel: string,
      userstate: tmi.ChatUserstate,
      message: string,
      _self: boolean
    ) => {
      if (!ignore) {
        channel = channel.replace("#", "");
        const m: Message = {
          channel: channel.replace("#", ""),
          userstate,
          message,
          timestamp: new Date().toLocaleTimeString(),
        };

        const chat = { ...chats[channel] };
        if (chat) {
          // limit the number of messages to 100
          if (chat.messages.length > 100) chat.messages.shift();
          chat.messages.push(m);
          setChats({ ...chats, [channel]: chat });
          localStorage.setItem(
            channel + "-messages",
            JSON.stringify(chat.messages)
          );
        }
      }
    };

    client.on("connected", onConnect);
    client.on("disconnected", onDisconnected);
    client.on("connecting", onConnecting);
    client.on("message", onMessage);

    return () => {
      ignore = true;
      client.removeListener("connected", onConnect);
      client.removeListener("disconnected", onDisconnected);
      client.removeListener("connecting", onConnecting);
      client.removeListener("message", onMessage);
    };
  }, [chats]);

  const joinChat = async (channel: string) => {
    if (Object.keys(chats).includes(channel)) {
      console.log("Chat already exists. Joining...");
      await client.join(channel);
      return;
    }

    try {
      await client.join(channel);
      const chat: Chat = {
        messages: [],
        status: "connected",
      };
      setChats({ ...chats, [channel]: chat });
      setChannels([...channels, channel]);
    } catch (error) {
      console.error(error);
    }
  };

  const leaveChat = async (channel: string) => {
    if (!Object.keys(chats).includes(channel)) return;

    try {
      await client.part(channel);
      const newChats = { ...chats };
      delete newChats[channel];
      setChats(newChats);
      setChannels(channels.filter((c) => c !== channel));
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <ChatContext.Provider
      value={{
        chats,
        status,
        channels,
        isLoading: false,
        joinChat,
        leaveChat,
      }}
    >
      {children}
    </ChatContext.Provider>
  );
};

export default ChatProvider;
