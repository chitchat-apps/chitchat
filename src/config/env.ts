const DEBUG = process.env.NODE_ENV !== "production";

/**
 * Base API url with no trailing "/" .
 *
 * Example: http://localhost:8000
 */
export const CHITCHAT_API_URL = DEBUG
  ? "http://localhost:8000"
  : "https://chitchat-apps-api.herokuapp.com";
