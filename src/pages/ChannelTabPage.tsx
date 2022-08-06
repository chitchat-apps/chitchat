import {
  Avatar,
  Box,
  Button,
  Heading,
  HStack,
  Input,
  InputGroup,
  InputRightAddon,
  useColorModeValue,
  VStack,
} from "@chakra-ui/react";
import { FC, useEffect, useRef, useState } from "react";
import ChannelContextMenu from "../components/ChannelContextMenu";
import ChatMessage from "../components/ChatMessage";
import LiveIndicator from "../components/LiveIndicator";
import useChat from "../hooks/useChat";
import useChats from "../hooks/useChats";
import { ChannelTab } from "../lib/tab";

export interface ChannelTabPageProps {
  tab: ChannelTab;
}

const ChannelTabPage: FC<ChannelTabPageProps> = ({ tab }) => {
  const { joinChat: addChat } = useChats();
  const chat = useChat(tab.channel);
  const [loading, setLoading] = useState<boolean | null>(null);
  const chatContainerRef = useRef<HTMLDivElement>(null);
  const chatBottomRef = useRef<HTMLDivElement>(null);

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
    scrollToBottom();
    return () => {
      ignore = true;
    };
  }, [chat, loading]);

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
        {chat?.messages.map((message, i) => (
          <ChatMessage key={`${message.id}-${i}`} message={message} />
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
