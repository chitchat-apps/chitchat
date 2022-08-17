import { HiUser } from "react-icons/hi";
import { SettingsIcon } from "@chakra-ui/icons";
import { Box, Button, HStack, Icon, Text, VStack } from "@chakra-ui/react";
import { FC, useState } from "react";
import {
  Link,
  Route,
  Routes,
  useLocation,
  useSearchParams,
} from "react-router-dom";
import AboutPage from "./AboutPage";
import GeneralPage from "./GeneralPage";
import UserPage from "./UserPage";

const SettingsPage: FC = () => {
  const [search] = useSearchParams();
  const [tab] = useState(search.get("tab"));

  return (
    <HStack w="100%" h="100%" spacing={4} py={4}>
      <SettingsSideBar />
      <VStack flex="1" m={4} w="100%" h="100%">
        <Box w="100%" h="100%" pt={2}>
          <Routes>
            <Route path="" element={<GeneralPage />} />
            <Route path="user" element={<UserPage />} />
            <Route path="about" element={<AboutPage />} />
          </Routes>
        </Box>
        <Box mt="auto !important" alignSelf="flex-end" pr={4}>
          <Button as={Link} to={tab ? `/home/${tab}` : "/home"}>
            Close
          </Button>
        </Box>
      </VStack>
    </HStack>
  );
};

export const SettingsSideBar: FC = () => {
  const location = useLocation();

  return (
    <VStack p={2} h="100%" minW="125px" spacing={6} align="stretch">
      <VStack spacing={0} align="stretch">
        <Button
          as={Link}
          to="/settings"
          isActive={location.pathname === "/settings"}
          variant="ghost"
          display="flex"
          justifyContent="start"
          leftIcon={<SettingsIcon />}
          iconSpacing={1}
        >
          General
        </Button>
        <Button
          as={Link}
          to="/settings/user"
          isActive={location.pathname === "/settings/user"}
          variant="ghost"
          display="flex"
          justifyContent="start"
          leftIcon={<Icon as={HiUser} />}
          iconSpacing={1}
        >
          User
        </Button>
      </VStack>
      <VStack spacing={0} align="stretch">
        <Button
          isDisabled
          variant="ghost"
          display="flex"
          justifyContent="start"
          leftIcon={<SettingsIcon />}
          iconSpacing={1}
        >
          Placeholder
        </Button>
        <Button
          isDisabled
          variant="ghost"
          display="flex"
          justifyContent="start"
          leftIcon={<SettingsIcon />}
          iconSpacing={1}
        >
          Placeholder
        </Button>
      </VStack>
      <VStack spacing={0} align="stretch" mt="auto !important">
        <Button
          as={Link}
          to="/settings/about"
          isActive={location.pathname === "/settings/about"}
          variant="ghost"
          display="flex"
          justifyContent="start"
        >
          About
        </Button>
      </VStack>
    </VStack>
  );
};

export default SettingsPage;
