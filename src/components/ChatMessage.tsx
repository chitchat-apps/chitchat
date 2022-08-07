import { BsDiamondFill } from "react-icons/bs";
import { Box, Icon, Text, useColorModeValue } from "@chakra-ui/react";
import { FC, useMemo } from "react";
import { Message, parseChatMessage } from "../lib/chat";
import { randomColor } from "@chakra-ui/theme-tools";
import {
  getLightnessOfColor,
  hexToRgb,
  rgbToHex,
  shadeColor,
} from "../utils/color";

interface ChatMessageProps {
  message: Message;
}

const ChatMessage: FC<ChatMessageProps> = ({ message }) => {
  const timestamp = useMemo(() => {
    const timestampArr = message.timestamp.split(":");
    return `${timestampArr[0]}:${timestampArr[1]}`;
  }, []);

  const color = useMemo(() => {
    const origColor = message.color || randomColor();
    const lightness = getLightnessOfColor(origColor);
    const colorType =
      lightness < 0.15 ? "dark" : lightness > 0.85 ? "light" : "ok";
    if (colorType === "ok") return origColor;
    return rgbToHex(
      shadeColor(hexToRgb(origColor), colorType === "dark" ? 40 : -40)
    );
  }, []);

  const purpleColor = useColorModeValue("purple.500", "purple.200");

  const messageTokens = useMemo(() => {
    return parseChatMessage(message.message).map((token, i) => (
      <>
        {i !== 0 && " "}
        <Text
          overflow="hidden"
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
            color: purpleColor,
            textDecor: "underline",
          })}
        >
          {token.text}
        </Text>
      </>
    ));
  }, []);

  return (
    <Box
      py={1}
      px={1}
      _hover={{
        bg: useColorModeValue("blackAlpha.100", "whiteAlpha.50"),
      }}
      rounded="md"
      w="100%"
      fontSize="sm"
    >
      <Text
        as="span"
        fontFamily="mono"
        fontSize="xs"
        color={useColorModeValue("gray.600", "gray.400")}
        mr={1}
      >
        {timestamp}
      </Text>
      {/* <Box
        as="span"
        display="inline-flex"
        justifyContent="center"
        mr={1}
        pos="relative"
        top={0.5}
      >
        <Icon
          as={BsDiamondFill}
          color="white"
          bg="pink.400"
          p="1px"
          rounded="sm"
        />
      </Box> */}
      <Text as="span" fontWeight="bold" color={color}>
        {message.displayName || message.username}:&nbsp;
      </Text>
      <Text as="span" wordBreak="break-word">
        {messageTokens}
      </Text>
    </Box>
  );
};

export default ChatMessage;
