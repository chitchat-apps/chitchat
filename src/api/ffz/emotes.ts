export interface FfzChannelEmote {
  id: string;
  code: string;
  imageType: string;
  images: {
    "1x": string;
    "2x": string;
    "4x": string;
  };
  user: {
    id: string;
    displayName: string;
    name: string;
  };
}

export const getFfzEmotes = async (id: string) => {
  if (id === "") return [];

  const res = await fetch(
    `https://api.betterttv.net/3/cached/frankerfacez/users/twitch/${id}`
  );

  if (!res.ok) return [];
  return res.json() as Promise<FfzChannelEmote[]>;
};
