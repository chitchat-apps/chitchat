import { AddIcon } from "@chakra-ui/icons";
import { Heading, VStack } from "@chakra-ui/react";
import { FC } from "react";
import { useNavigate, useParams } from "react-router-dom";
import TopBar from "../components/TopBar";
import ChatProvider from "../context/chatContext";
import StreamsProvider from "../context/streamsContext";
import useTabs from "../hooks/useTabs";
import { Tab } from "../lib/tab";
import TabPage from "./TabPage";

const HomePage: FC = () => {
  const { id } = useParams();
  const { tabs } = useTabs();
  const tabExists = tabs.some((tab) => tab.id === id);

  return (
    <ChatProvider>
      <StreamsProvider>
        <TopBar />
        {tabExists ? <TabPage /> : <NoTabs />}
      </StreamsProvider>
    </ChatProvider>
  );
};

const NoTabs: FC = () => {
  const { addTab } = useTabs();
  const navigate = useNavigate();

  const handleAddTab = () => {
    const newTab = new Tab("empty");
    addTab(newTab);
    navigate(`/home/${newTab.id}`);
  };

  return (
    <VStack
      h="100%"
      justify="center"
      align="center"
      cursor="pointer"
      onClick={handleAddTab}
    >
      <Heading size="lg">Click to add a tab</Heading>
      <Heading size="md">
        <AddIcon />
      </Heading>
    </VStack>
  );
};
export default HomePage;
