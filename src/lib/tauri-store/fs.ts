import {
  createDir,
  readDir,
  readTextFile,
  writeFile,
} from "@tauri-apps/api/fs";
import { appDir, join } from "@tauri-apps/api/path";
import { ConfigOptions, EnsureConfigFileResponse, Status } from "./types";
import { DEFAULT_OPTIONS } from "./constants";

export const writeConfig = async <ConfigSchema extends {} = any>(
  newConfig: ConfigSchema,
  path: string,
  options: ConfigOptions
) => {
  return writeFile(
    path,
    JSON.stringify(
      newConfig,
      null,
      options.prettify ? options.numberOfSpaces : 0
    )
  );
};

export const readConfig = async <ConfigSchema extends {} = any>(
  defaultConfig: ConfigSchema,
  options: ConfigOptions = DEFAULT_OPTIONS
): Promise<{ config: ConfigSchema; path: string; status: Status }> => {
  const ensuredConfig = await ensureConfigFile<ConfigSchema>(
    defaultConfig,
    options
  );

  return {
    config: JSON.parse(ensuredConfig.contents) as ConfigSchema,
    path: ensuredConfig.path,
    status: ensuredConfig.status,
  };
};

export const ensureConfigFile = async <ConfigSchema extends {}>(
  defaultConfig: ConfigSchema,
  options: ConfigOptions
): Promise<EnsureConfigFileResponse> => {
  const configFilePath = await join(
    await appDir(),
    options.directory,
    options.filename
  );

  try {
    await readDir(await appDir());
  } catch (error) {
    // Create the directory if it doesn't exist.
    try {
      await createDir(await appDir());
    } catch (err) {
      console.log("Error creating app directory:", err);
      throw err;
    }
  }

  try {
    const contents = await readTextFile(configFilePath);

    return {
      contents,
      path: configFilePath,
      status: Status.FILE_EXISTS,
    };
  } catch (error) {
    // Create the config file if it doesn't exist.

    console.log("Config file does not exist. Creating...");

    const contents = JSON.stringify(
      defaultConfig,
      null,
      options.prettify ? options.numberOfSpaces : 0
    );

    try {
      await writeFile({
        contents,
        path: configFilePath,
      });
    } catch (err) {
      console.log("Error creating config file:", err);
      throw err;
    }

    return {
      contents,
      path: configFilePath,
      status: Status.FILE_CREATED,
    };
  }
};
