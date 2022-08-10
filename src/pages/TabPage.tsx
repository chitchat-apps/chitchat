import { AddIcon } from "@chakra-ui/icons";
import {
  Button,
  Heading,
  Modal,
  ModalBody,
  ModalContent,
  ModalFooter,
  ModalOverlay,
  TabList,
  Tabs,
  useDisclosure,
  VStack,
  Tab as ChakraTab,
  TabPanels,
  TabPanel,
  FormControl,
  Input,
  Text,
  Tooltip,
  Box,
  FormErrorMessage,
  Spinner,
  Center,
  useColorModeValue,
} from "@chakra-ui/react";
import React, { FC, useEffect, useRef, useState } from "react";
import useChats from "../hooks/useChats";
import useTab from "../hooks/useTab";
import useTabs from "../hooks/useTabs";
import { ChannelTab, Tab, TabType } from "../lib/tab";
import ChannelTabPage from "./ChannelTabPage";
import useBadges from "../hooks/useBadges";
import useEmotes from "../hooks/useEmotes";
import { useQuery } from "@tanstack/react-query";
import { getUser } from "../api/chitchat";

const TabPage = () => {
  const tab = useTab();
  const { isLoading: isLoadingChats } = useChats();
  const { isLoading: isLoadingBadges } = useBadges();
  const { isLoading: isLoadingEmotes } = useEmotes();

  const { data: channel, isLoading: isLoadingChannel } = useQuery(
    ["channel", (tab as ChannelTab | undefined)?.channel],
    () => getUser((tab as ChannelTab).channel),
    {
      enabled: tab instanceof ChannelTab,
      refetchInterval: 1000 * 60 * 2, // 2 minutes
    }
  );

  useEffect(() => {
    if (tab) localStorage.setItem("activeTab", tab.id);
    else localStorage.removeItem("activeTab");
  }, [tab]);

  if (!tab) return null;

  const isLoading =
    isLoadingBadges || isLoadingChats || isLoadingEmotes || isLoadingChannel;
  if (tab instanceof ChannelTab)
    return isLoading ? (
      <LoadingTab size="lg" />
    ) : (
      <ChannelTabPage tab={tab} channel={channel} />
    );
  return <EmptyTab tab={tab} />;
};

const LoadingTab: FC<{ color?: string; size?: string }> = ({
  color,
  size = "md",
}) => (
  <Center h="full">
    <Spinner
      size={size}
      color={color || useColorModeValue("purple.500", "purple.200")}
    />
  </Center>
);

const EmptyTab: FC<{ tab: Tab }> = ({ tab }) => {
  const { joinChat } = useChats();
  const { updateTab } = useTabs();
  const initialFocusRef = useRef<HTMLInputElement>(null);
  const { isOpen, onOpen, onClose } = useDisclosure({ defaultIsOpen: true });
  const [tabIndex, setTabIndex] = useState(0);
  const [channel, setChannel] = useState("");
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    onOpen();
  }, [tab]);

  const handleAdd = async (
    e:
      | React.FormEvent<HTMLFormElement>
      | React.MouseEvent<HTMLButtonElement, MouseEvent>
  ) => {
    e.preventDefault();
    setError(null);
    const selectedTab = tabIndex as TabType;
    switch (selectedTab) {
      case TabType.Channel:
        if (channel !== "") {
          updateTab(tab.id, new ChannelTab(channel));
          setChannel("");
          onClose();
          await joinChat(channel);
        } else setError("Please provide a channel name");
        break;
      // case TabType.Mentions:
      //   console.log("Add mentions");
      //   break;
      // case TabType.Whisper:
      //   console.log("Add whisper");
      //   break;
      // case TabType.Watching:
      //   console.log("Add watching");
      //   break;
      default:
        break;
    }
  };

  return (
    <>
      <VStack
        h="100%"
        justify="center"
        align="center"
        cursor="pointer"
        onClick={onOpen}
      >
        <Heading size="lg">Click to add a chat</Heading>
        <Heading size="md">
          <AddIcon />
        </Heading>
      </VStack>
      <Modal
        isOpen={isOpen}
        onClose={onClose}
        isCentered
        initialFocusRef={initialFocusRef}
        size="md"
        onCloseComplete={() => {
          setError(null);
          setChannel("");
        }}
      >
        <ModalOverlay />
        <ModalContent mx={2}>
          <ModalBody py={0}>
            <Tabs
              isFitted
              pt={3}
              variant="soft-rounded"
              colorScheme="purple"
              onChange={setTabIndex}
            >
              <TabList overflowX="auto">
                <ChakraTab fontSize="xs" py={1} px={1}>
                  Channel
                </ChakraTab>
                <ChakraTab fontSize="xs" py={1} px={1}>
                  Whisper
                </ChakraTab>
                <ChakraTab fontSize="xs" py={1} px={1}>
                  Mentions
                </ChakraTab>
                <ChakraTab fontSize="xs" py={1} px={1}>
                  Watching
                </ChakraTab>
              </TabList>

              <TabPanels
                h="65px"
                pt={4}
                display="flex"
                alignItems="center"
                justifyContent="stretch"
                fontSize="sm"
              >
                <TabPanel p={0} w="100%">
                  <form onSubmit={handleAdd}>
                    <FormControl isInvalid={error !== null}>
                      <Input
                        value={channel}
                        onChange={(e) => setChannel(e.target.value)}
                        colorScheme="purple"
                        placeholder="Channel name"
                        ref={initialFocusRef}
                        size="sm"
                      />
                      <FormErrorMessage>{error}</FormErrorMessage>
                    </FormControl>
                  </form>
                </TabPanel>
                <TabPanel p={0} w="100%">
                  <Text textAlign="center">
                    Whispers you get while ChitChat is running.
                  </Text>
                </TabPanel>
                <TabPanel p={0} w="100%">
                  <Text textAlign="center">
                    Mentions you get from any open channel.
                  </Text>
                </TabPanel>
                <TabPanel p={0} w="100%">
                  <Text textAlign="center">
                    The current channel you're watching. Requires ChitChat
                    browser extension.
                  </Text>
                </TabPanel>
              </TabPanels>
            </Tabs>
          </ModalBody>

          <ModalFooter justifyContent="center">
            <Button
              mr={3}
              onClick={onClose}
              flex="1"
              colorScheme="gray"
              size="xs"
            >
              Cancel
            </Button>
            <Box flex="1">
              <Tooltip
                label="Not available"
                placement="top"
                hasArrow
                arrowSize={6}
                isDisabled={tabIndex === 0}
                shouldWrapChildren
                w="100%"
                offset={[0, 18]}
                openDelay={200}
              >
                <Button
                  w="100%"
                  onClick={handleAdd}
                  isDisabled={tabIndex !== 0}
                  size="xs"
                >
                  Ok
                </Button>
              </Tooltip>
            </Box>
          </ModalFooter>
        </ModalContent>
      </Modal>
    </>
  );
};

export default TabPage;
