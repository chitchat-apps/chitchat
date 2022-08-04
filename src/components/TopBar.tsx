import { HStack, IconButton, useColorMode } from "@chakra-ui/react";
import { SettingsIcon } from "@chakra-ui/icons";
import { FC } from "react";
import TopBarTab from "./TopBarTab";
import { WebviewWindow } from "@tauri-apps/api/window";

const TopBar: FC = () => {
  const handleSettingsClick = () => {
    console.log("Settings clicked");
    const window = new WebviewWindow("Settings");

    window.once("tauri://created", (e) => {
      console.log("Settings window created");
    });

    window.once("tauri://error", (e) => {
      console.log(e);
    });
  };

  return (
    <HStack spacing={0} shadow="sm">
      <IconButton
        variant="ghost"
        size="sm"
        icon={<SettingsIcon />}
        aria-label="Settings"
        rounded="none"
        onClick={handleSettingsClick}
      />
      <TopBarTab label="SebbDev" active />
      <TopBarTab label="Channel2" />
      <TopBarTab label="Channel3" />
    </HStack>
  );
};

export default TopBar;
