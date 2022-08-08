import { CSSProperties } from "react";
import { BadgeInfo, Badges, Userstate } from "tmi.js";
import { BadgeSet } from "../api/twitch";

export interface Message {
  channel: string;
  message: string;
  timestamp: string;
  userstate: Userstate;
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
  isImage?: boolean;
  imgSrc?: string;
}

export interface BadgeToken {
  style?: CSSProperties;
  src: string;
  alt: string;
}

export interface EmoteReplacement {
  start: number;
  end: number;
  id: string;
}

export const getTwitchEmoteUrl = (emoteId: string, size: 1 | 2 | 3 | 4 = 1) =>
  `https://static-cdn.jtvnw.net/emoticons/v1/${emoteId}/${size}.0`;

export const parseChatMessage = (
  message: string,
  emotes?: { [emoteId: string]: string[] }
): MessageToken[] => {
  const tokens: MessageToken[] = [];
  const messageArr = message.split(" ");

  const emoteArr = getEmoteArray(emotes);

  let startIndex = 0;
  messageArr.forEach((word) => {
    const indexes: { start: number; end: number } = {
      start: startIndex,
      end: startIndex + word.length,
    };
    startIndex += word.length + 1;

    const emote = emoteArr.find(
      (e) => e.start === indexes.start && e.end === indexes.end - 1
    );
    if (emotes && emote) {
      tokens.push({
        text: word,
        isImage: true,
        imgSrc: getTwitchEmoteUrl(emote.id),
      });
    } else if (isLink(word)) {
      tokens.push({
        text: word,
        isLink: true,
      });
    } else {
      tokens.push({
        text: word,
        style: styles.mention,
      });
    }
  });

  return tokens;
};

function getEmoteArray(emotes: { [emoteId: string]: string[] } | undefined) {
  const emotesArr: EmoteReplacement[] = [];
  Object.keys(emotes || {}).forEach((key, i) => {
    let em = (emotes || {})[key];
    em.forEach((ele) => {
      const indexes = ele.split("-");
      let start = parseInt(indexes[0]);
      let end = parseInt(indexes[1]);
      emotesArr.push({
        start,
        end,
        id: Object.keys(emotes || {})[i],
      });
    });
  });

  emotesArr.sort(compareEnd);
  emotesArr.reverse();

  return emotesArr;
}

function compareEnd(a: EmoteReplacement, b: EmoteReplacement) {
  if (a.end < b.end) {
    return -1;
  }
  if (a.end > b.end) {
    return 1;
  }
  return 0;
}

function isLink(token: string) {
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
}

export function parseChatBadges(
  badges: Partial<Badges> | undefined,
  badgeSet: { [badge: string]: BadgeSet }
) {
  const badgeTokens: BadgeToken[] = [];
  if (!badges) return badgeTokens;

  Object.keys(badges).forEach((key) => {
    const b = badgeSet[key];
    const v = badges[key];
    if (!b || !v) return;
    const version = b.versions[v];
    if (!version) return;
    badgeTokens.push({
      src: version.image_url_1x,
      alt: key,
    });
  });
  return badgeTokens;
}

const styles: { [key: string]: CSSProperties } = {
  mention: {
    fontWeight: "bold",
  },
};
