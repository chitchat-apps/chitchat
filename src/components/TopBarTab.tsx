import { Button, useColorModeValue } from "@chakra-ui/react";
import { CloseIcon } from "@chakra-ui/icons";
import { FC, useState } from "react";

export type TopBarTabProps = {
  icon?: React.ReactElement;
  label: string;
  active?: boolean;
  onClick?: (event: React.MouseEvent<HTMLButtonElement, MouseEvent>) => void;
};

const TopBarTab: FC<TopBarTabProps> = (props) => {
  const [hovering, setHovering] = useState(false);
  const redColor = useColorModeValue("red.500", "red.200");
  const textColor = useColorModeValue("white", "gray.800");
  const grayColor = useColorModeValue("gray.200", "whiteAlpha.300");

  return (
    <Button
      size="sm"
      rounded="none"
      variant={props.active ? "solid" : "ghost"}
      bg={props.active ? grayColor : undefined}
      onClick={props.onClick}
      leftIcon={props.icon}
      fontSize="xs"
      onMouseEnter={() => setHovering(true)}
      onMouseLeave={() => setHovering(false)}
    >
      {props.label}{" "}
      {(hovering || props.active) && (
        <CloseIcon
          cursor="pointer"
          ml={1}
          w="12px"
          h="12px"
          p="2px"
          rounded="sm"
          _hover={{ bg: redColor, color: textColor }}
        />
      )}
    </Button>
  );
};

export default TopBarTab;
