import { Container } from "@chakra-ui/react";
import React from "react";

export type LayoutProps = {
  children: React.ReactNode;
};

const Layout: React.FC<LayoutProps> = ({ children }) => {
  return (
    <Container m={0} p={0} maxW="none" minH="full" h="full">
      {children}
    </Container>
  );
};

export default Layout;
