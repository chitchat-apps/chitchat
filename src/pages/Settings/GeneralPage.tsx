import { Box, Button, Flex, useColorMode } from "@chakra-ui/react";
import { FC } from "react";

const GeneralPage: FC = () => {
  const { toggleColorMode } = useColorMode();

  return (
    <Flex justify="center">
      <Button onClick={toggleColorMode}>Toggle Theme</Button>
    </Flex>
  );
};

export default GeneralPage;
