import {
  Box,
  Circle,
  keyframes,
  PlacementWithLogical,
  SquareProps,
  Tooltip,
  useColorModeValue,
  useTheme,
} from "@chakra-ui/react";
import { FC } from "react";
import { getColor } from "../utils/chakra-color";

export interface LiveIndicatorProps extends SquareProps {
  isLive?: boolean;
  isDisabled?: boolean;
  divWhenDisabled?: boolean;
  size?: number;
  noTooltip?: boolean;
  tooltipPlacement?: PlacementWithLogical;
}

const LiveIndicator: FC<LiveIndicatorProps> = ({
  isLive = true,
  isDisabled = false,
  divWhenDisabled = false,
  noTooltip = false,
  size = 3.5,
  tooltipPlacement = "right",
  ...restProps
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
        placement={tooltipPlacement}
        hasArrow
        arrowSize={4}
        fontSize="xs"
        isDisabled={noTooltip}
        openDelay={500}
      >
        <Circle
          ml={2}
          animation={pulseAnimation}
          size={size}
          bg={bg}
          {...restProps}
        />
      </Tooltip>
    );
  return (
    <Tooltip
      label="Offline"
      placement={tooltipPlacement}
      hasArrow
      arrowSize={4}
      fontSize="xs"
      isDisabled={noTooltip}
      openDelay={500}
    >
      <Circle ml={2} size={size} bg="gray.500" {...restProps} />
    </Tooltip>
  );
};

export default LiveIndicator;
