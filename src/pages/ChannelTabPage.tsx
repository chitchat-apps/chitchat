import {
  Avatar,
  Box,
  Button,
  ChakraProvider,
  Divider,
  Heading,
  HStack,
  Input,
  InputGroup,
  InputRightAddon,
  Text,
  Tooltip,
  useColorModeValue,
  VStack,
} from "@chakra-ui/react";
import { FC, useEffect, useRef, useState } from "react";
import { createRoot, Root } from "react-dom/client";
import { chakraTheme } from "../App";
import ChannelContextMenu from "../components/ChannelContextMenu";
import ChatMessage from "../components/ChatMessage";
import LiveIndicator from "../components/LiveIndicator";
import useChat from "../hooks/useChat";
import useChats from "../hooks/useChats";
import { ChannelTab } from "../lib/tab";
import { ChatUserstate } from "tmi.js";
import { Message } from "../lib/chat";
import { v4 } from "uuid";
import BadgeProvider from "../context/badgeContext";
import { QueryClientProvider, useQueryClient } from "@tanstack/react-query";
import useBadges from "../hooks/useBadges";
import EmoteProvider from "../context/emotesContext";
import useEmotes from "../hooks/useEmotes";
import { client } from "../context/chatContext";
import { BroadcasterType, User } from "../api/chitchat";
import useStream from "../hooks/useStream";
import { BttvChannelEmote } from "../api/bttv";
import { FfzChannelEmote } from "../api/ffz";

export interface ChannelTabPageProps {
  tab: ChannelTab;
  channel?: User;
  bttvEmotes?: BttvChannelEmote[];
  ffzEmotes?: FfzChannelEmote[];
}

const ChannelTabPage: FC<ChannelTabPageProps> = ({
  tab,
  channel,
  bttvEmotes = [],
  ffzEmotes = [],
}) => {
  const queryClient = useQueryClient();
  const { joinChat: addChat } = useChats();
  const chat = useChat(tab.channel);
  const badges = useBadges();
  const emotes = useEmotes();
  const stream = useStream(tab.channel);

  const [loading, setLoading] = useState<boolean | null>(null);
  const chatContainerRef = useRef<HTMLDivElement>(null);
  const chatBottomRef = useRef<HTMLDivElement>(null);
  const initialMessagesRef = useRef<HTMLDivElement>(null);
  const firstRender = useRef(true);
  const rootRef = useRef<Root | null>(null);
  const shouldAddTempMessages = useRef<boolean>(false);

  const [stopScroll, setStopScroll] = useState(false);

  const [messages, setMessages] = useState<Message[]>([]);
  const [tempMessages, setTempMessages] = useState<Message[]>([]);

  const scrollToBottom = (override = false) => {
    if (!stopScroll && !override) {
      chatBottomRef.current?.scrollIntoView();
    }
  };

  useEffect(() => {
    if (stopScroll) {
      if (!shouldAddTempMessages.current) setTempMessages([]);
      shouldAddTempMessages.current = true;
    } else {
      setMessages((messages) => {
        if (shouldAddTempMessages.current) {
          shouldAddTempMessages.current = false;
          messages.push(...tempMessages);
        }
        // limit the number of messages to 100
        while (messages.length > 100) messages.shift();
        return messages;
      });
      setTimeout(() => scrollToBottom(true), 500);
    }
  }, [stopScroll, tempMessages]);

  useEffect(() => {
    let ignore = false;
    if (!chat && loading === null) {
      setLoading(true);
      addChat(tab.channel).then(() => {
        if (!ignore) {
          setLoading(false);
        }
      });
    } else if (loading) setLoading(false);

    const onMessage = (
      channel: string,
      userstate: ChatUserstate,
      message: string,
      _self: boolean
    ) => {
      if (channel === "#" + tab.channel) {
        const m: Message = {
          channel: channel.replace("#", ""),
          userstate,
          message,
          timestamp: new Date().toLocaleTimeString(),
        };
        const addMsg = (messages: Message[]) => {
          // limit the number of messages to 100
          while (messages.length > 100) messages.shift();
          messages.push(m);
          return messages;
        };

        if (stopScroll) setTempMessages(addMsg);
        else setMessages(addMsg);
      }
    };
    client.on("message", onMessage);

    scrollToBottom();

    return () => {
      ignore = true;
      client.removeListener("message", onMessage);
    };
  }, [chat, loading, tab, stopScroll, tempMessages]);

  useEffect(() => {
    if (chat) {
      if (
        firstRender.current &&
        initialMessagesRef.current &&
        !rootRef.current
      ) {
        firstRender.current = false;

        const messages = chat.messages.map((message, i) => {
          const id = (message.userstate.id || v4()) + "-" + i;
          return (
            <ChatMessage
              key={id}
              id={id}
              message={message.message}
              color={message.userstate.color}
              username={
                message.userstate["display-name"] || message.userstate.username
              }
              timestamp={message.timestamp}
              emotes={message.userstate.emotes}
              badges={message.userstate.badges}
              bttvEmotes={bttvEmotes}
              ffzEmotes={ffzEmotes}
            />
          );
        });

        // add all messages to the chat container
        rootRef.current = createRoot(initialMessagesRef.current);
        rootRef.current.render(
          <ChakraProvider theme={chakraTheme}>
            <QueryClientProvider client={queryClient}>
              <EmoteProvider initialGlobalBttvEmotes={emotes.bttvEmotes}>
                <BadgeProvider initialBadges={badges.badges}>
                  {messages}
                </BadgeProvider>
              </EmoteProvider>
            </QueryClientProvider>
          </ChakraProvider>
        );

        setTimeout(scrollToBottom, 500);
      }
    }

    setMessages([]);

    return () => {
      firstRender.current = true;
    };
  }, [tab]);

  useEffect(() => {
    const onScroll = () => {
      if (chatContainerRef.current) {
        setStopScroll(true);
      }
    };

    if (chatContainerRef.current) {
      chatContainerRef.current.addEventListener("wheel", onScroll);
    }

    return () => {
      if (chatContainerRef.current) {
        chatContainerRef.current.removeEventListener("wheel", onScroll);
      }
    };
  }, [tab]);

  return (
    //            TODO : Refactor this
    <Box flex="1" pos="relative" maxH="calc(100% - 2.5rem)">
      <HStack
        p={1}
        justifyContent="space-between"
        bg={useColorModeValue("blackAlpha.50", "whiteAlpha.50")}
      >
        {/* <Box /> */}
        <HStack spacing={1}>
          <LiveIndicator
            divWhenDisabled
            isLive={stream !== undefined}
            noTooltip
          />
          <Text fontWeight="bold" fontSize="xs">
            {stream === undefined ? "Offline" : "Live"}
          </Text>
        </HStack>
        <Tooltip
          placement="right"
          label="Partner"
          isDisabled={channel?.broadcasterType !== BroadcasterType.Partner}
          hasArrow
          arrowSize={4}
          openDelay={500}
        >
          <Heading
            size="sm"
            display="flex"
            justifyContent="center"
            alignItems="center"
          >
            {/* TODO : Change to channel picture */}
            <Avatar
              size="xs"
              mr={1}
              name={tab.channel}
              src={channel?.profileImageUrl}
            />
            {channel?.displayName}
          </Heading>
        </Tooltip>
        <ChannelContextMenu />
      </HStack>

      <VStack
        p={1}
        align="start"
        spacing={0}
        maxH="calc(100% - 5rem)"
        overflowY="scroll"
        overflowX="hidden"
        ref={chatContainerRef}
      >
        {/* <ChatMessage username="SebbDev" message="Hello there 👋" />
        <ChatMessage username="Grievous" message="🤨" />
        <ChatMessage username="Grievous" message="General Kenobi 🤖" /> */}
        <VStack w="full" spacing={0} ref={initialMessagesRef} opacity={0.75} />
        <VStack
          key="initial-message-separator"
          w="full"
          p={2}
          justify="flex-start"
          align="flex-start"
          spacing={1}
        >
          <Divider
            orientation="horizontal"
            borderColor={useColorModeValue("purple.500", "purple.200")}
            borderBottomWidth="1px"
          />
          <Text
            fontSize="sm"
            color={useColorModeValue("purple.500", "purple.200")}
          >
            Welcome to the chat room!
          </Text>
        </VStack>
        {messages.map((m, i) => (
          <ChatMessage
            key={m.userstate.id || v4() + "-" + i}
            id={m.userstate.id || v4() + "-" + i}
            message={m.message}
            color={m.userstate.color}
            username={m.userstate["display-name"] || m.userstate.username}
            timestamp={m.timestamp}
            emotes={m.userstate.emotes}
            badges={m.userstate.badges}
            bttvEmotes={bttvEmotes}
            ffzEmotes={ffzEmotes}
          />
        ))}
        <Box ref={chatBottomRef} />
      </VStack>
      {stopScroll && (
        <Button
          variant="solid"
          left="50%"
          transform="translateX(-50%)"
          w="full"
          maxW="xs"
          pos="absolute"
          bottom={12}
          p={2}
          opacity={0.75}
          _hover={{ opacity: 1 }}
          rounded="md"
          onClick={() => {
            setStopScroll(false);
            scrollToBottom(true);
          }}
          size="sm"
        >
          <Text textAlign="center">Chat paused due to scroll</Text>
        </Button>
      )}
      <Box px={2} w="full" pos="absolute" bottom={0}>
        <InputGroup>
          {/*TODO : Implement this */}
          <Input variant="filled" placeholder="Send message" isDisabled />
          <InputRightAddon>
            <Button borderLeftRadius={0} isDisabled>
              Send
            </Button>
          </InputRightAddon>
        </InputGroup>
      </Box>
    </Box>
  );
};

export default ChannelTabPage;
