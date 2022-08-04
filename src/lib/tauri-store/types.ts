export interface EnsureConfigFileResponse {
  contents: string;
  path: string;
  status: Status;
}

export enum Status {
  FILE_EXISTS = "file_exists",
  FILE_CREATED = "file_created",
}

export interface IConfig {
  /**
   * The filename of the config file.
   */
  filename: string;
  /**
   * The path to the config file.
   * Note: Is currently not supported.
   */
  directory: string;
  /**
   * Whether the JSON should be formatted when saved.
   */
  prettify: boolean;
  /**
   * The indentation of the JSON when formatted. Only works when {@link prettify} is true.
   */
  numberOfSpaces: number;
}

export type ConfigOptions = IConfig;
