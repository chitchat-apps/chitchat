import { memoizedGet as get } from "@chakra-ui/utils";

export const getColor = (theme: { [key: string]: any }, color: string) =>
  get(theme, `colors.${color}`);
