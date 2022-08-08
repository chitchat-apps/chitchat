import { useContext } from "react";
import { ChatContext } from "../context/chatContext";

/**
 * Returns the chat for the provided channel.
 */
const useChat = (channel: string) => {
  const chatContext = useContext(ChatContext);
  if (!chatContext) throw new Error("ChatContext not found");

  return chatContext.chats[channel];
};

export default useChat;
