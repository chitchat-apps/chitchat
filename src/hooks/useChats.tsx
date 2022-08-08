import { useContext } from "react";
import { ChatContext } from "../context/chatContext";

const useChats = () => {
  const chats = useContext(ChatContext);
  if (!chats) throw new Error("ChatContext not found");
  return chats;
};

export default useChats;
