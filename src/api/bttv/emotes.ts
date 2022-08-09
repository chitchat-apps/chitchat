export interface BttvEmote {
  id: string;
  code: string;
  imageType: string;
  userId: string;
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
