import { clamp } from "./numbers";

export interface RGB {
  r: number;
  g: number;
  b: number;
}

export function getLightnessOfColor(rgb: RGB): number;

export function getLightnessOfColor(hexString: string): number;

export function getLightnessOfColor(color: any) {
  if (typeof color === "string") color = hexToRgb(color);

  let { r, g, b } = color as RGB;
  r = clamp(r, 0, 255);
  g = clamp(g, 0, 255);
  b = clamp(b, 0, 255);

  const highest = Math.max(r, g, b);
  const lowest = Math.min(r, g, b);
  return (highest + lowest) / 2 / 255;
}

export function lighten(hex: string, amount: number): string {
  try {
    const rgb = hexToRgb(hex);
    const lmh = getLowestMiddleHighest(rgb);

    if (lmh.lowest.val === 255) return rgbToHex(rgb);

    const newLmh = { ...lmh };

    newLmh.lowest.val = Math.round(
      lmh.lowest.val + Math.min(255 - lmh.lowest.val, amount)
    );

    const increaseFraction =
      (newLmh.lowest.val - lmh.lowest.val) / (255 - lmh.lowest.val);

    newLmh.middle.val = Math.round(
      lmh.middle.val + (255 - lmh.middle.val) * increaseFraction
    );
    newLmh.highest.val =
      lmh.highest.val + (255 - lmh.highest.val) * increaseFraction;

    const values = Object.values(newLmh);
    const r = values.find((val) => val.name === "r")!;
    const g = values.find((val) => val.name === "g")!;
    const b = values.find((val) => val.name === "b")!;

    return rgbToHex({ r: r.val, g: g.val, b: b.val });
  } catch (error) {
    return hex;
  }
}

export function darken(hex: string, amount: number): string {
  return lighten(hex, -amount);
}

function getLowestMiddleHighest(rgb: RGB) {
  try {
    const lmh = {
      lowest: { name: "", val: Infinity },
      middle: { name: "", val: -1 },
      highest: { name: "", val: -1 },
    };
    for (const key in rgb) {
      const val = rgb[key as keyof RGB];
      if (val > lmh.highest.val) {
        lmh.highest.name = key;
        lmh.highest.val = val;
      }
      if (val < lmh.lowest.val) {
        lmh.lowest.name = key;
        lmh.lowest.val = val;
      }
    }

    if (lmh.lowest.name === lmh.highest.name)
      lmh.lowest.name = lmh.highest.name;

    // get the remaining key name for the middle value
    lmh.middle.name = Object.keys(rgb).find(
      (key) => key !== lmh.lowest.name && key !== lmh.highest.name
    )!;
    lmh.middle.val = rgb[lmh.middle.name as keyof RGB];

    return lmh;
  } catch (error) {
    return {
      lowest: { name: "r", val: 0 },
      middle: { name: "g", val: 0 },
      highest: { name: "b", val: 0 },
    };
  }
}

export function hexToRgb(hex: string): RGB {
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);

  if (result && result.length === 4) {
    return {
      r: parseInt(result[1], 16),
      g: parseInt(result[2], 16),
      b: parseInt(result[3], 16),
    };
  }
  return { r: 0, g: 0, b: 0 };
}

export function rgbToHex(rgb: RGB): string {
  const { r, g, b } = rgb;
  return `#${r.toString(16)}${g.toString(16)}${b.toString(16)}`;
}

export function shadeColor(rgb: RGB, percent: number) {
  const { r, g, b } = rgb;
  const newRgb: RGB = { ...rgb };

  newRgb.r = clamp(Math.round((r * (100 + percent)) / 100), 0, 255);
  newRgb.g = clamp(Math.round((g * (100 + percent)) / 100), 0, 255);
  newRgb.b = clamp(Math.round((b * (100 + percent)) / 100), 0, 255);

  return newRgb;
}
