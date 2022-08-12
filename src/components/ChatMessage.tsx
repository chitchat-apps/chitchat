import { Box, Img, Text, useColorModeValue } from "@chakra-ui/react";
import { FC, Fragment, useMemo } from "react";
import { parseChatBadges, parseChatMessage } from "../lib/chat";
import { randomColor } from "@chakra-ui/theme-tools";
import {
  getLightnessOfColor,
  hexToRgb,
  rgbToHex,
  shadeColor,
} from "../utils/color";
import { Badges } from "tmi.js";
import useBadges from "../hooks/useBadges";
import useEmotes from "../hooks/useEmotes";
import { BttvChannelEmote } from "../api/bttv";

interface ChatMessageProps {
  id: string;
  message: string;
  color?: string;
  username: string;
  timestamp: string;
  emotes?: { [emoteId: string]: string[] };
  badges?: Badges;
  bttvEmotes?: BttvChannelEmote[];
}

const ChatMessage: FC<ChatMessageProps> = ({
  id,
  message,
  color,
  username,
  timestamp,
  emotes,
  badges,
  bttvEmotes: bttvChannelEmotes = [],
}) => {
  const { bttvEmotes } = useEmotes();
  const badgeContext = useBadges();

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
    return parseChatMessage(
      message,
      emotes,
      bttvEmotes.concat(bttvChannelEmotes)
    ).map((token, i) => {
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
              target="_blank"
              rel="noopener noreferrer"
            >
              {token.text}
            </Text>
          </Fragment>
        );
      if (token.isImage)
        return (
          <Text
            as="span"
            display="inline-flex"
            key={key}
            h="1rem"
            w="1rem"
            pos="relative"
            justifyContent="center"
            align="center"
            mx="4px"
          >
            <Img
              maxW="1.5rem"
              display="inline-block"
              pos="absolute"
              bottom={-1}
              src={token.imgSrc}
              alt={token.text}
            />
            &nbsp;
          </Text>
        );

      return (
        <Fragment key={key}>
          {i !== 0 && <span> </span>}
          <Text as="span">{token.text}</Text>
        </Fragment>
      );
    });
  }, []);

  const badgeFragments = useMemo(() => {
    return parseChatBadges(badges, badgeContext.badges).map((token, i) => (
      <Text
        as="span"
        display="inline-flex"
        key={`${id}-${token.alt}`}
        h="1rem"
        w="1rem"
        pos="relative"
        justifyContent="center"
        align="center"
        ml={i === 0 ? 0 : 1}
      >
        <Img
          src={token.src}
          display="inline"
          pos="relative"
          bottom="-3px"
          h="1rem"
          w="1rem"
          mr="2px"
        />
      </Text>
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
        mb={1}
      >
        {_timestamp}
      </Text>
      {badgeFragments}
      <Text as="span" fontWeight="bold" color={_color}>
        {username}:&nbsp;
      </Text>
      {messageFragments}
    </Box>
  );
};

export default ChatMessage;
