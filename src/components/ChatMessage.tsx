import { Box, Image, Text, useColorModeValue } from "@chakra-ui/react";
import { FC, Fragment, useMemo } from "react";
import { parseChatMessage } from "../lib/chat";
import { randomColor } from "@chakra-ui/theme-tools";
import {
  getLightnessOfColor,
  hexToRgb,
  rgbToHex,
  shadeColor,
} from "../utils/color";

interface ChatMessageProps {
  id: string;
  message: string;
  color?: string;
  username: string;
  timestamp: string;
  emotes?: { [emoteId: string]: string[] };
}

const ChatMessage: FC<ChatMessageProps> = ({
  id,
  message,
  color,
  username,
  timestamp,
  emotes,
}) => {
  const _timestamp = useMemo(() => {
    const timestampArr = timestamp.split(":");
    return `${timestampArr[0]}:${timestampArr[1]}`;
  }, []);

  const _color = useMemo(() => {
    const origColor = color || randomColor();
    const lightness = getLightnessOfColor(origColor);
    const colorType =
      lightness < 0.15 ? "dark" : lightness > 0.85 ? "light" : "ok";
    if (colorType === "ok") return origColor;
    return rgbToHex(
      shadeColor(hexToRgb(origColor), colorType === "dark" ? 40 : -40)
    );
  }, []);

  const purpleColor = useColorModeValue("purple.500", "purple.200");

  const messageFragments = useMemo(() => {
    return parseChatMessage(message, emotes).map((token, i) => {
      const key = `${id}-${token.text}-${i}`;

      if (token.isLink)
        return (
          <Fragment key={key}>
            {i !== 0 && <span> </span>}
            <Text
              as="a"
              href={token.text}
              color={purpleColor}
              textDecor="underline"
            >
              {token.text}
            </Text>
          </Fragment>
        );
      if (token.isImage)
        return (
          <Fragment key={key}>
            {i !== 0 && <span> </span>}
            <Image
              display="inline"
              pos="relative"
              bottom={-1}
              src={token.imgSrc}
              alt={token.text}
              h="1.5rem"
            />
          </Fragment>
        );

      return (
        <Fragment key={key}>
          {i !== 0 && <span> </span>}
          <Text as="span">{token.text}</Text>
        </Fragment>
      );
    });
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
        {_timestamp}
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
      <Text as="span" fontWeight="bold" color={_color}>
        {username}:&nbsp;
      </Text>
      {messageFragments}
      {/* <Text
        dangerouslySetInnerHTML={{ __html:  }}
        as="span"
        wordBreak="break-word"
      ></Text> */}
    </Box>
  );
};

export default ChatMessage;
