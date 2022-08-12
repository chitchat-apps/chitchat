interface SevenTvEmoteResponse {
  id: string;
  name: string;
  owner: {
    id: string;
    twitch_id: string;
    login: string;
    display_name: string;
    role: {
      id: string;
      name: string;
      position: number;
      color: number;
      allowed: number;
      denied: number;
    };
  };
  visibility: number;
  visibility_simple: number[];
  mime: string;
  status: number;
  tags: string[];
  width: number[];
  height: number[];
  urls: [
    [string, string],
    [string, string],
    [string, string],
    [string, string]
  ];
}

export interface SevenTvChannelEmote {
  id: string;
  code: string;
  urls: {
    "1": string;
    "2": string;
    "3": string;
    "4": string;
  };
  owner: {
    id: string;
    username: string;
    displayName: string;
    twitchId: string;
  };
}

export const getSevenTvEmotes = async (
  id: string
): Promise<SevenTvChannelEmote[]> => {
  if (id === "") return [];

  const res = await fetch(`https://7tv.io/v2/users/${id}/emotes`);

  if (!res.ok) return [];

  const json = (await res.json()) as SevenTvEmoteResponse[];

  return json.map((e) => ({
    id: e.id,
    code: e.name,
    urls: {
      "1": e.urls[0][1],
      "2": e.urls[1][1],
      "3": e.urls[2][1],
      "4": e.urls[3][1],
    },
    owner: {
      id: e.owner.id,
      username: e.owner.login,
      displayName: e.owner.display_name,
      twitchId: e.owner.twitch_id,
    },
  }));
};
