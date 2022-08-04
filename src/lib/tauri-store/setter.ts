import { ConfigOptions } from "./types";
import { readConfig, writeConfig } from "./fs";

export const set = async <
  ConfigSchema extends {} = any,
  K extends keyof ConfigSchema = keyof ConfigSchema
>(
  key: K,
  value: ConfigSchema[K],
  options: ConfigOptions
): Promise<ConfigSchema> => {
  const config = await readConfig<ConfigSchema>({} as ConfigSchema, options);
  config.config[key] = value;

  await writeConfig<ConfigSchema>(config.config, config.path, options);

  return config.config;
};
