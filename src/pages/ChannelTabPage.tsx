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
  useColorModeValue,
  VStack,
} from "@chakra-ui/react";
import { FC, useEffect, useRef, useState } from "react";
import { renderToString } from "react-dom/server";
import { createRoot, Root } from "react-dom/client";
import { chakraTheme } from "../App";
import ChannelContextMenu from "../components/ChannelContextMenu";
import ChatMessage from "../components/ChatMessage";
import LiveIndicator from "../components/LiveIndicator";
import useChat from "../hooks/useChat";
import useChats from "../hooks/useChats";
import { ChannelTab } from "../lib/tab";
import { client } from "../context/chatContext";
import { ChatUserstate } from "tmi.js";
import { Message } from "../lib/chat";

export interface ChannelTabPageProps {
  tab: ChannelTab;
}

const ChannelTabPage: FC<ChannelTabPageProps> = ({ tab }) => {
  const { joinChat: addChat } = useChats();
  const chat = useChat(tab.channel);
  const [loading, setLoading] = useState<boolean | null>(null);
  const chatContainerRef = useRef<HTMLDivElement>(null);
  const chatBottomRef = useRef<HTMLDivElement>(null);
  const initialMessagesRef = useRef<HTMLDivElement>(null);
  const firstRender = useRef(true);
  const rootRef = useRef<Root | null>(null);

  const [messages, setMessages] = useState<Message[]>([]);

  const scrollToBottom = () => {
    chatBottomRef.current?.scrollIntoView();
  };

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
          id: userstate.id || "",
          userId: userstate["user-id"] || "",
          username: userstate.username || "",
          displayName: userstate.displayName || "",
          color: userstate.color || "",
          message,
          timestamp: new Date().toLocaleTimeString(),
        };
        setMessages((messages) => {
          // limit the number of messages to 100
          while (messages.length > 100) messages.shift();
          messages.push(m);
          return messages;
        });
      }
    };
    client.on("message", onMessage);

    scrollToBottom();

    return () => {
      ignore = true;
      client.removeListener("message", onMessage);
    };
  }, [chat, loading, tab]);

  useEffect(() => {
    if (chat) {
      if (firstRender.current && initialMessagesRef.current) {
        firstRender.current = false;

        // add all messages to the chat container
        if (!rootRef.current)
          rootRef.current = createRoot(initialMessagesRef.current);

        const messages = chat.messages.map((message, i) => (
          <ChatMessage key={`${message.id}-${i}`} message={message} />
        ));
        rootRef.current.render(
          <ChakraProvider theme={chakraTheme}>{messages}</ChakraProvider>
        );
        setTimeout(scrollToBottom, 500);
      }
    }

    setMessages([]);

    return () => {
      firstRender.current = true;
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
        <LiveIndicator divWhenDisabled isLive />
        <Heading
          size="sm"
          display="flex"
          justifyContent="center"
          alignItems="center"
        >
          {/* TODO : Change to channel picture */}
          <Avatar size="xs" mr={1} name={tab.channel} />
          {tab.channel}
        </Heading>
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
        <VStack spacing={0} ref={initialMessagesRef} opacity={0.5} />
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
        {messages.map((m) => (
          <ChatMessage key={m.id} message={m} />
        ))}
        <Box ref={chatBottomRef} />
      </VStack>
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
