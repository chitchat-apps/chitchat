import { BsDiamondFill } from "react-icons/bs";
import {
  Box,
  HStack,
  Icon,
  Text,
  Tooltip,
  useColorModeValue,
} from "@chakra-ui/react";
import { FC } from "react";
import { Message, parseChatMessage } from "../lib/chat";
import { randomColor } from "@chakra-ui/theme-tools";
import { darken, getLightnessOfColor, lighten } from "../utils/color";

interface ChatMessageProps {
  message: Message;
}

const ChatMessage: FC<ChatMessageProps> = ({ message }) => {
  const timestampArr = message.timestamp.split(":");
  const timestamp = `${timestampArr[0]}:${timestampArr[1]}`;

  const origColor = message.color || randomColor();
  const lightness = getLightnessOfColor(origColor);
  const colorType = lightness < 0.1 ? "dark" : lightness > 0.9 ? "light" : "ok";
  const color =
    colorType === "dark"
      ? lighten(origColor || randomColor(), 200)
      : colorType === "light"
      ? darken(origColor || randomColor(), 200)
      : origColor;

  return (
    <Box
      py="1px"
      px={1}
      _hover={{
        bg: useColorModeValue("blackAlpha.100", "whiteAlpha.50"),
      }}
      rounded="md"
      w="100%"
    >
      <HStack spacing={1} flexWrap="wrap">
        <Text
          fontFamily="mono"
          fontSize="xs"
          color={useColorModeValue("gray.600", "gray.400")}
        >
          {timestamp}
        </Text>
        <Tooltip label="VIP" placement="top" hasArrow arrowSize={5}>
          <Box display="flex" justifyContent="center">
            <Icon
              as={BsDiamondFill}
              color="white"
              bg="pink.400"
              p="2px"
              rounded="sm"
            />
          </Box>
        </Tooltip>
        <Text fontWeight="bold" color={color || randomColor()}>
          {message.displayName || message.username}:
        </Text>
        <Text>
          {parseChatMessage(message.message).map((token, i) => (
            <Text
              key={`token-${i}-${message.id}`}
              as="span"
              style={token.style}
              {...(token.isLink && {
                as: "a",
                href: token.text.startsWith("http")
                  ? token.text
                  : "https://" + token.text,
                target: "_blank",
                rel: "noopener noreferrer",
                color: useColorModeValue("purple.500", "purple.200"),
                textDecor: "underline",
              })}
            >
              {i !== 0 && " "}
              {token.text}
            </Text>
          ))}
        </Text>
      </HStack>
    </Box>
  );
};

export default ChatMessage;
