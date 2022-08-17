import { createContext, FC, ReactNode, useEffect, useState } from "react";
import tmi from "tmi.js";
import { Chat, IChatContext, Message } from "../lib/chat";
import useTmiClient from "../hooks/useTmiClient";
import { getChannelsFromLs } from "./tmiClientContext";

export const ChatContext = createContext<IChatContext | null>(null);

const ChatProvider: FC<{
  children: ReactNode;
}> = ({ children }) => {
  const { client } = useTmiClient();

  const [channels, setChannels] = useState<string[]>([]);

  const [chats, setChats] = useState<{ [key: string]: Chat }>(() => {
    const chats: { [key: string]: Chat } = {};
    getChannelsFromLs().forEach((channel) => {
      const messages = [];
      const lsMessages = localStorage.getItem(`${channel}-messages`);
      if (lsMessages) {
        const m = JSON.parse(lsMessages) as Message[];
        messages.push(...m);
      }

      chats[channel] = {
        messages,
        status: "connected",
      };
    });
    setChannels(Object.keys(chats));
    return chats;
  });

  useEffect(() => {
    let ignore = false;

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

    client.on("message", onMessage);

    return () => {
      ignore = true;
      client.removeListener("message", onMessage);
    };
  }, [chats, client]);

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
