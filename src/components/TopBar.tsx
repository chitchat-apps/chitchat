import { HStack, IconButton, useColorModeValue } from "@chakra-ui/react";
import { AddIcon, SettingsIcon } from "@chakra-ui/icons";
import { FC } from "react";
import TopBarTab from "./TopBarTab";
import { Link, useNavigate } from "react-router-dom";
import { Tab } from "../lib/tab";
import useTabs from "../hooks/useTabs";
import useTab from "../hooks/useTab";

const TopBar: FC = () => {
  const navigate = useNavigate();
  const { tabs, addTab } = useTabs();
  const currentTab = useTab();

  const handleAddTab = () => {
    const newTab = new Tab("empty");
    addTab(newTab);
    navigate(`/home/${newTab.id}`);
  };

  return (
    <HStack
      spacing={0}
      flexWrap="wrap"
      bg={useColorModeValue("blackAlpha.50", "whiteAlpha.50")}
    >
      <IconButton
        as={Link}
        to={`/settings?tab=${currentTab?.id}`}
        variant="ghost"
        size="sm"
        icon={<SettingsIcon />}
        aria-label="Settings"
        rounded="none"
      />
      {tabs.map((t) => (
        <TopBarTab key={t.id} tab={t} />
      ))}
      <IconButton
        variant="ghost"
        size="sm"
        icon={<AddIcon />}
        aria-label="Settings"
        rounded="none"
        onClick={handleAddTab}
      />
    </HStack>
  );
};

export default TopBar;
