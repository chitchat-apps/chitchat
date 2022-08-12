export interface BttvEmote {
  id: string;
  code: string;
  imageType: string;
  userId: string;
}

export interface BttvChannelEmote extends BttvEmote {
  user: {
    id: string;
    displayName: string;
    name: string;
    providerId: string;
  };
}

interface BttvChannelEmoteResponse {
  id: string;
  avatar: string;
  bots: string[];
  channelEmotes: BttvChannelEmote[];
  sharedEmotes: BttvChannelEmote[];
}

export const bttvGlobalEmotesEndpoint =
  "https://api.betterttv.net/3/cached/emotes/global";

export const getBttvGlobalEmotes = async () => {
  const res = await fetch(bttvGlobalEmotesEndpoint);
  const json = await res.json();
  if (res.ok) {
    return json as BttvEmote[];
  }
  throw new Error("Failed to get BTTV global emotes");
};

export const getBttvEmotes = async (id: string) => {
  if (id === "") return [];

  const res = await fetch(
    `https://api.betterttv.net/3/cached/users/twitch/${id}`
  );

  if (!res.ok) return [];

  const json = (await res.json()) as BttvChannelEmoteResponse;

  const emotes: BttvChannelEmote[] = [];
  json.channelEmotes.forEach((e) => emotes.push(e));
  json.sharedEmotes.forEach((e) => emotes.push(e));
  return emotes;
};
