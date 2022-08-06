import {
  Box,
  Circle,
  keyframes,
  Tooltip,
  useColorModeValue,
  useTheme,
} from "@chakra-ui/react";
import { FC } from "react";
import { getColor } from "../utils/chakra-color";

export interface LiveIndicatorProps {
  isLive?: boolean;
  isDisabled?: boolean;
  divWhenDisabled?: boolean;
}

const LiveIndicator: FC<LiveIndicatorProps> = ({
  isLive = true,
  isDisabled = false,
  divWhenDisabled = false,
}) => {
  const theme = useTheme();
  const bg = useColorModeValue("red.500", "red.400");

  const animation = keyframes`
    0% {
      transform: scale(0.95);
      box-shadow: 0 0 0 0 ${getColor(theme, bg)}40;
    }
    70% {
      transform: scale(1);
      box-shadow: 0 0 0 10px ${getColor(theme, bg)}00;
    }

    100% {
      transform: scale(0.95);
      box-shadow: 0 0 0 0 ${getColor(theme, bg)}00;
    }
`;
  const pulseAnimation = `${animation} 1.25s infinite`;

  if (isDisabled) return divWhenDisabled ? <Box /> : null;
  if (isLive)
    return (
      <Tooltip
        label="Live"
        placement="right"
        hasArrow
        arrowSize={4}
        fontSize="xs"
      >
        <Circle ml={2} animation={pulseAnimation} size={3.5} bg={bg} />
      </Tooltip>
    );
  return (
    <Tooltip
      label="Offline"
      placement="right"
      hasArrow
      arrowSize={4}
      fontSize="xs"
    >
      <Circle
        ml={2}
        size={3.5}
        bg="gray.500"
        boxShadow={`0 0 0 5px ${getColor(theme, "gray.500")}40`}
      />
    </Tooltip>
  );
};

export default LiveIndicator;
