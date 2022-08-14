import { Heading, Text, VStack } from "@chakra-ui/react";
import { FC } from "react";
import { getVersion } from "@tauri-apps/api/app";

const version = await getVersion();

const AboutPage: FC = () => {
  return (
    <VStack w="100%" h="100%" align="center" justify="center" spacing={0}>
      <VStack spacing={0} align="start">
        <Heading textAlign="left">ChitChat</Heading>
        <Text textAlign="left">Version {version}</Text>
      </VStack>
    </VStack>
  );
};

export default AboutPage;
