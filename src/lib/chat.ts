import React, { CSSProperties } from "react";

export interface Message {
  id: string;
  userId: string;
  username: string;
  displayName: string;
  color: string;
  message: string;
  timestamp: string;
}

export type Status = "connected" | "disconnected" | "connecting";

export interface Chat {
  messages: Message[];
  status: Status;
}

export interface IChatContext {
  chats: { [key: string]: Chat };
  status: Status;
  joinChat: (channel: string) => Promise<void>;
  leaveChat: (channel: string) => Promise<void>;
}

export interface MessageToken {
  style?: CSSProperties;
  text: string;
  isLink?: boolean;
}

export const parseChatMessage = (message: string): MessageToken[] => {
  const textArr = message.split(" ");
  const elements: MessageToken[] = [];

  for (const token of textArr) {
    if (token.startsWith("@"))
      elements.push({ text: token, style: { fontWeight: "bold" } });
    else if (isLink(token)) elements.push({ text: token, isLink: true });
    else elements.push({ text: token });
  }

  return elements;
};

const isLink = (token: string): boolean => {
  const pattern = new RegExp(
    "^(https?:\\/\\/)?" + // protocol
      "((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|" + // domain name
      "((\\d{1,3}\\.){3}\\d{1,3}))" + // OR ip (v4) address
      "(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*" + // port and path
      "(\\?[;&a-z\\d%_.~+=-]*)?" + // query string
      "(\\#[-a-z\\d_]*)?$",
    "i"
  ); // fragment locator
  return !!pattern.test(token);
};
