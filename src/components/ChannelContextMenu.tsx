import { CloseIcon, ExternalLinkIcon, RepeatIcon } from "@chakra-ui/icons";
import {
  Icon,
  IconButton,
  Menu,
  MenuButton,
  MenuDivider,
  MenuItem,
  MenuList,
} from "@chakra-ui/react";
import React from "react";
import { HiDotsVertical } from "react-icons/hi";
import { useNavigate } from "react-router-dom";
import useChats from "../hooks/useChats";
import useTab from "../hooks/useTab";
import useTabs from "../hooks/useTabs";
import { ChannelTab } from "../lib/tab";
import { getPrevOrNextIndex } from "../utils/lists";

const ChannelContextMenu = () => {
  const navigate = useNavigate();
  const { tabs, removeTab } = useTabs();
  const { leaveChat } = useChats();
  const tab = useTab()! as ChannelTab;

  const handleRemoveTab = async (e: React.MouseEvent<Element, MouseEvent>) => {
    e.preventDefault();
    const currentTabIndex = tabs.indexOf(tab);
    const tabLength = tabs.length;
    const nextTabIndex = getPrevOrNextIndex(currentTabIndex, tabLength);
    const nextTabId = nextTabIndex === -1 ? null : tabs[nextTabIndex].id;

    removeTab(tab.id);
    await leaveChat(tab.channel);
    if (nextTabId) return navigate(`/home/${nextTabId}`);
    navigate("/home");
  };

  return (
    <>
      <Menu placement="left-end">
        <MenuButton
          as={IconButton}
          size="sm"
          variant="ghost"
          aria-label="Settings"
          icon={<Icon as={HiDotsVertical} />}
        />
        <MenuList py={1}>
          <MenuItem fontSize="sm" py={1} icon={<RepeatIcon />} iconSpacing={2}>
            Reconnect
          </MenuItem>
          <MenuItem
            fontSize="sm"
            py={1}
            icon={<ExternalLinkIcon />}
            iconSpacing={2}
          >
            Open in browser
          </MenuItem>
          <MenuDivider />
          <MenuItem
            fontSize="sm"
            py={1}
            icon={<CloseIcon />}
            iconSpacing={2}
            onClick={handleRemoveTab}
          >
            Close
          </MenuItem>
        </MenuList>
      </Menu>
    </>
  );
};

export default ChannelContextMenu;
