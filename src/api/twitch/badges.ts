export interface BadgeVersion {
  click_action: string;
  click_url: string;
  description: string;
  image_url_1x: string;
  image_url_2x: string;
  image_url_4x: string;
  last_updated: null | string;
  title: string;
}

export interface BadgeSet {
  versions: {
    [key: string]: BadgeVersion;
  };
}

export interface BadgeResponse {
  badge_sets: { [badge: string]: BadgeSet };
}

export interface ErrorResponse {
  message: string;
  error: string;
  status: number;
}

export const getGlobalBadges = async () => {
  const res = await fetch("https://badges.twitch.tv/v1/badges/global/display");
  const json = await res.json();
  if (res.ok) {
    const data = json as BadgeResponse;
    return data.badge_sets;
  }
  throw new Error((json as ErrorResponse).message);
};
