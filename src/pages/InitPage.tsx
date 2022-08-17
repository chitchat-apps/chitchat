import {
  VStack,
  Heading,
  Spinner,
  HStack,
  useColorModeValue,
} from "@chakra-ui/react";
import React, { useEffect, useState } from "react";
import { Navigate } from "react-router-dom";
import useAuth from "../hooks/useAuth";
import useTabs from "../hooks/useTabs";

const InitPage: React.FC = () => {
  const purpleColor = useColorModeValue("purple.500", "purple.200");

  const { loadTabs, isInitialized } = useTabs();
  const { isLoading } = useAuth();
  const [activeTab, setActiveTab] = useState<string | null>(null);

  useEffect(() => {
    setActiveTab(loadTabs());
  }, []);

  if (!isInitialized || isLoading)
    return (
      <VStack h="100%" justify="center" align="center" spacing={4}>
        <Heading size="2xl">ChitChat</Heading>
        <HStack>
          <Heading fontWeight="normal" size="md" color={purpleColor}>
            Starting...
          </Heading>
          <Spinner size="md" color={purpleColor} />
        </HStack>
      </VStack>
    );
  return <Navigate to={`/home/` + (activeTab ? activeTab : "")} />;
};

export default InitPage;
