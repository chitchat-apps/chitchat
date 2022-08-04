import { ConfigOptions } from "./types";
import { DEFAULT_OPTIONS } from "./constants";
import { readConfig } from "./fs";

export const get = async <
  ConfigSchema extends {} = any,
  K extends keyof ConfigSchema = keyof ConfigSchema
>(
  key: K,
  options: ConfigOptions
): Promise<ConfigSchema[K]> => {
  if (await has<ConfigSchema>(key, options))
    return (await readConfig<ConfigSchema>({} as ConfigSchema, options)).config[
      key
    ];
  throw new Error(`Key not found.`);
};

export const has = async <ConfigSchema extends {} = any>(
  key: keyof ConfigSchema,
  options: ConfigOptions = DEFAULT_OPTIONS
): Promise<boolean> =>
  key in (await readConfig<ConfigSchema>({} as ConfigSchema, options)).config;
