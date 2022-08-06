import { clamp } from "./numbers";

export const getPrevOrNextIndex = (
  currentIndex: number,
  listLength: number
) => {
  if (currentIndex === 0) {
    const newIndex = clamp(currentIndex + 1, -1, listLength - 1);
    if (newIndex === 0) return -1;
    return newIndex;
  }
  return Math.max(currentIndex - 1, -1);
};
