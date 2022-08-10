import { CHITCHAT_API_URL } from "../../config/env";

export interface UserResponse {
  broadcaster_type: string;
  created_at: Date;
  description: string;
  display_name: string;
  id: string;
  login: string;
  offline_image_url: string;
  profile_image_url: string;
  type: string;
  view_count: number;
}

export enum BroadcasterType {
  Partner = "partner",
  Affiliate = "affiliate",
  None = "",
}

export interface User {
  id: string;
  broadcasterType: BroadcasterType;
  displayName: string;
  username: string;
  description: string;
  profileImageUrl: string;
  offlineImageUrl: string;
  viewCount: number;
  createdAt: Date;
}

export const getUser = async (username: string): Promise<User> => {
  const res = await fetch(`${CHITCHAT_API_URL}/users?username=${username}`);
  const json = await res.json();
  if (res.ok) {
    const data = json as UserResponse[];
    const user = data[0];
    return {
      id: user.id,
      broadcasterType: user.broadcaster_type as BroadcasterType,
      displayName: user.display_name,
      username: user.login,
      description: user.description,
      profileImageUrl: user.profile_image_url,
      offlineImageUrl: user.offline_image_url,
      viewCount: user.view_count,
      createdAt: user.created_at,
    };
  }
  throw new Error(json.message);
};
