import { FC } from "react";
import { ChakraProvider, extendTheme } from "@chakra-ui/react";
import Layout from "./components/Layout";
import InitPage from "./pages/InitPage";
import { MemoryRouter, Routes, Route } from "react-router-dom";
import HomePage from "./pages/HomePage";

const theme = extendTheme({
  initialColorMode: "dark",
  useSystemColorMode: true,
});

export const App: FC = () => {
  return (
    <ChakraProvider theme={theme}>
      <Layout>
        <MemoryRouter>
          <Routes>
            <Route path="/" element={<InitPage />} />
            <Route path="/home" element={<HomePage />} />
          </Routes>
        </MemoryRouter>
      </Layout>
    </ChakraProvider>
  );
};

export default App;
