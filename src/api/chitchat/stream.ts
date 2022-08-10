import { CHITCHAT_API_URL } from "../../config/env";

export interface StreamsResponse {
  game_id: string;
  game_name: string;
  id: string;
  is_mature: boolean;
  language: string;
  started_at: Date;
  tag_ids: string[];
  thumbnail_url: string;
  title: string;
  type: string;
  user_id: string;
  user_login: string;
  user_name: string;
  viewer_count: number;
}

export enum StreamType {
  Live = "live",
  None = "",
}

export interface Stream {
  id: string;
  gameId: string;
  gameName: string;
  title: string;
  startedAt: Date;
  viewerCount: number;
  thumbnailUrl: string;
  language: string;
  isMature: boolean;
  type: StreamType;
  userId: string;
  username: string;
  displayName: string;
  tagIds: string[];
}

export const getStreams = async (streams: string[]): Promise<Stream[]> => {
  const queryString =
    "?" + streams.map((stream) => `stream=${stream}`).join("&");
  const res = await fetch(`${CHITCHAT_API_URL}/streams?${queryString}`);
  const json = await res.json();
  if (res.ok) {
    const data = json as StreamsResponse[];
    return data.map((stream) => ({
      id: stream.id,
      gameId: stream.game_id,
      gameName: stream.game_name,
      title: stream.title,
      startedAt: stream.started_at,
      viewerCount: stream.viewer_count,
      thumbnailUrl: stream.thumbnail_url,
      language: stream.language,
      isMature: stream.is_mature,
      type: stream.type as StreamType,
      userId: stream.user_id,
      username: stream.user_login,
      displayName: stream.user_name,
      tagIds: stream.tag_ids,
    }));
  }
  throw new Error(json.message);
};
