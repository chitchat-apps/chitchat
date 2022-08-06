import { Button, useColorModeValue } from "@chakra-ui/react";
import { CloseIcon } from "@chakra-ui/icons";
import React, { FC, useState } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import useTabs from "../hooks/useTabs";
import { getPrevOrNextIndex } from "../utils/lists";
import { ChannelTab, Tab } from "../lib/tab";
import useChats from "../hooks/useChats";

export type TopBarTabProps = {
  icon?: React.ReactElement;
  tab: Tab;
};

const TopBarTab: FC<TopBarTabProps> = (props) => {
  const { tabs, removeTab } = useTabs();
  const { leaveChat } = useChats();
  const navigate = useNavigate();
  const location = useLocation();
  const isActive = location.pathname === `/home/${props.tab.id}`;

  const [hovering, setHovering] = useState(false);
  const redColor = useColorModeValue("red.500", "red.200");
  const textColor = useColorModeValue("white", "gray.800");

  const handleRemoveTab = async (e: React.MouseEvent<Element, MouseEvent>) => {
    e.preventDefault();
    const currentTabIndex = tabs.indexOf(props.tab);
    const tabLength = tabs.length;
    const nextTabIndex = getPrevOrNextIndex(currentTabIndex, tabLength);
    const nextTabId = nextTabIndex === -1 ? null : tabs[nextTabIndex].id;

    removeTab(props.tab.id);
    if ("channel" in props.tab) {
      await leaveChat((props.tab as ChannelTab).channel);
    }
    if (nextTabId) return navigate(`/home/${nextTabId}`);
    navigate("/home");
  };

  return (
    <Button
      as={Link}
      to={`/home/${props.tab.id}`}
      size="sm"
      rounded="none"
      variant={isActive ? "solid" : "ghost"}
      fontWeight={isActive ? "bold" : undefined}
      leftIcon={props.icon}
      fontSize="xs"
      onMouseEnter={() => setHovering(true)}
      onMouseLeave={() => setHovering(false)}
    >
      {props.tab.label}{" "}
      {(hovering || isActive) && (
        <CloseIcon
          cursor="pointer"
          ml={1}
          w="12px"
          h="12px"
          p="2px"
          rounded="sm"
          _hover={{ bg: redColor, color: textColor }}
          onClick={handleRemoveTab}
        />
      )}
    </Button>
  );
};

export default TopBarTab;
