import { VStack, Heading, Spinner, HStack } from "@chakra-ui/react";
import React, { useEffect } from "react";
import { useNavigate } from "react-router-dom";

const InitPage: React.FC = () => {
  const navigate = useNavigate();

  useEffect(() => {
    setTimeout(() => {
      navigate("/home");
    }, 5000);
  }, []);

  return (
    <VStack h="100%" justify="center" align="center" spacing={4}>
      <Heading size="2xl">ChitChat</Heading>
      <HStack>
        <Heading fontWeight="normal" size="md">
          Starting...
        </Heading>
        <Spinner size="md" />
      </HStack>
    </VStack>
  );
};

export default InitPage;
