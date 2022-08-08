import {
  VStack,
  Heading,
  Spinner,
  HStack,
  useColorModeValue,
} from "@chakra-ui/react";
import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import useTabs from "../hooks/useTabs";

const InitPage: React.FC = () => {
  const navigate = useNavigate();
  const { loadTabs, isInitialized } = useTabs();
  const [activeTab, setActiveTab] = useState<string | null>(null);

  useEffect(() => {
    setActiveTab(loadTabs());
  }, []);

  useEffect(() => {
    if (isInitialized) {
      new Promise((resolve) => setTimeout(resolve, 1000)).then(() =>
        navigate("/home/" + (activeTab ? activeTab : ""))
      );
    }
  }, [isInitialized, activeTab]);

  return (
    <VStack h="100%" justify="center" align="center" spacing={4}>
      <Heading size="2xl">ChitChat</Heading>
      <HStack>
        <Heading
          fontWeight="normal"
          size="md"
          color={useColorModeValue("purple.500", "purple.200")}
        >
          Starting...
        </Heading>
        <Spinner
          size="md"
          color={useColorModeValue("purple.500", "purple.200")}
        />
      </HStack>
    </VStack>
  );
};

export default InitPage;
