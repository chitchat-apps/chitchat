import { Box, Heading, Text, VStack } from "@chakra-ui/react";
import { FC } from "react";

const AboutPage: FC = () => {
  return (
    <VStack w="100%" h="100%" align="center" justify="center" spacing={0}>
      <VStack spacing={0} align="start">
        <Heading textAlign="left">ChitChat</Heading>
        <Text textAlign="left">Version 0.0.1</Text>
      </VStack>
    </VStack>
  );
};

export default AboutPage;
