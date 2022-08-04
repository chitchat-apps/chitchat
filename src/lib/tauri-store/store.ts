import { DEFAULT_OPTIONS } from "./constants";
import { readConfig, writeConfig } from "./fs";
import { get, has } from "./getter";
import { set } from "./setter";
import { ConfigOptions, Status } from "./types";

export class Store<ConfigSchema extends {}> {
  config: ConfigSchema;

  path: string;

  options: ConfigOptions;

  protected constructor(
    config: ConfigSchema,
    options: ConfigOptions,
    path: string
  ) {
    this.config = { ...config };
    this.options = { ...options };
    this.path = path;
  }

  static async create<ConfigSchema extends {}>(
    defaultConfig: ConfigSchema,
    options: ConfigOptions = DEFAULT_OPTIONS
  ) {
    const currentConfig = await readConfig<ConfigSchema>(
      defaultConfig,
      options
    );

    if (currentConfig.status === Status.FILE_CREATED)
      return new Store<ConfigSchema>(
        defaultConfig,
        options,
        currentConfig.path
      );
    return new Store<ConfigSchema>(
      currentConfig.config,
      options,
      currentConfig.path
    );
  }

  protected async writeConfig() {
    await writeConfig(this.config, this.path, this.options);
  }

  hasCache(key: keyof ConfigSchema) {
    return key in this.config;
  }

  getCache(key: keyof ConfigSchema) {
    if (this.hasCache(key)) return this.config[key];
    throw new Error("Key not found.");
  }

  setCache<K extends keyof ConfigSchema = keyof ConfigSchema>(
    key: K,
    value: ConfigSchema[K]
  ) {
    this.config[key] = value;
  }

  async has(key: keyof ConfigSchema): Promise<boolean> {
    return has<ConfigSchema>(key, this.options);
  }

  async get<K extends keyof ConfigSchema = keyof ConfigSchema>(
    key: K
  ): Promise<ConfigSchema[K]> {
    if (await this.has(key)) {
      const value = await get<ConfigSchema, K>(key, this.options);
      this.setCache(key, value);
      return value;
    }
    throw new Error("Key not found.");
  }

  async set<K extends keyof ConfigSchema = keyof ConfigSchema>(
    key: K,
    value: ConfigSchema[K]
  ): Promise<ConfigSchema> {
    this.setCache(key, value);
    return set<ConfigSchema, K>(key, value, this.options);
  }

  async syncCache(): Promise<ConfigSchema> {
    await this.writeConfig();
    return this.config;
  }
}
