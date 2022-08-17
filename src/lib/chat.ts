import { CSSProperties } from "react";
import { Badges, Userstate } from "tmi.js";
import { BttvEmote } from "../api/bttv";
import { FfzChannelEmote } from "../api/ffz";
import { SevenTvChannelEmote } from "../api/sevenTv";
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
  channels: string[];
  isLoading: boolean;
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

export const getBttvEmoteUrl = (emoteId: string, size: 1 | 2 | 3 = 1) =>
  `https://cdn.betterttv.net/emote/${emoteId}/${size}x`;

export const getFfzEmoteUrl = (emoteId: string, size: 1 | 2 | 4 = 1) =>
  `https://cdn.frankerfacez.com/emote/${emoteId}/${size}`;

export interface ParseChatMessageOptions {
  message: string;
  emotes?: { [emoteId: string]: string[] };
  bttvEmotes?: BttvEmote[];
  ffzEmotes?: FfzChannelEmote[];
  sevenTvEmotes?: SevenTvChannelEmote[];
}

export const parseChatMessage = ({
  message,
  emotes,
  bttvEmotes = [],
  ffzEmotes = [],
  sevenTvEmotes = [],
}: ParseChatMessageOptions): MessageToken[] => {
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

    if (emotes) {
      const twitchEmote = emoteArr.find(
        (e) => e.start === indexes.start && e.end === indexes.end - 1
      );
      if (twitchEmote) {
        tokens.push({
          text: word,
          isImage: true,
          imgSrc: getTwitchEmoteUrl(twitchEmote.id),
        });
        return;
      }
    }

    const bttvEmote = bttvEmotes.find((e) => e.code === word);
    if (bttvEmote) {
      tokens.push({
        text: word,
        isImage: true,
        imgSrc: getBttvEmoteUrl(bttvEmote.id, 2),
      });
      return;
    }

    const ffzEmote = ffzEmotes.find((e) => e.code === word);
    if (ffzEmote) {
      tokens.push({
        text: word,
        isImage: true,
        imgSrc: getFfzEmoteUrl(ffzEmote.id, 2),
      });
      return;
    }

    const sevenTvEmote = sevenTvEmotes.find((e) => e.code === word);
    if (sevenTvEmote) {
      tokens.push({
        text: word,
        isImage: true,
        imgSrc: sevenTvEmote.urls[2],
      });
      return;
    }

    if (isLink(word)) {
      tokens.push({
        text: word,
        isLink: true,
      });
      return;
    }

    tokens.push({
      text: word,
      style:
        word.startsWith("@") || word.startsWith("#")
          ? styles.mention
          : undefined,
    });
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

const linkRegex =
  /[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)/g;
function isLink(token: string) {
  // INFO : Old patter that is causing issues.
  // const pattern = new RegExp(
  //   "^(https?:\\/\\/)?" + // protocol
  //     "((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|" + // domain name
  //     "((\\d{1,3}\\.){3}\\d{1,3}))" + // OR ip (v4) address
  //     "(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*" + // port and path
  //     "(\\?[;&a-z\\d%_.~+=-]*)?" + // query string
  //     "(\\#[-a-z\\d_]*)?$",
  //   "i"
  // ); // fragment locator
  // token.match()
  // return !!pattern.test(token);
  return !!linkRegex.test(token);
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
