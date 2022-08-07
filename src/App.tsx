import "@fontsource/poppins";
import "@fontsource/roboto-mono";

import { FC, ReactElement } from "react";
import {
  ChakraProvider,
  extendTheme,
  ComponentMultiStyleConfig,
  withDefaultColorScheme,
} from "@chakra-ui/react";
import Layout from "./components/Layout";
import InitPage from "./pages/InitPage";
import {
  Routes,
  Route,
  BrowserRouter,
  Navigate,
  useMatch,
} from "react-router-dom";
import HomePage from "./pages/HomePage";
import SettingsPage from "./pages/Settings/SettingsPage";
import TabProvider from "./context/tabContext";
import TabPage from "./pages/TabPage";
import useTabs from "./hooks/useTabs";
import { getColor } from "./utils/chakra-color";

const inputStyle: ComponentMultiStyleConfig = {
  parts: ["field"],
  variants: {
    outline: (props) => ({
      field: {
        _focusVisible: {
          zIndex: 1,
          borderColor: `${props.colorScheme}.${
            props.colorMode === "light" ? 500 : 200
          }`,
          boxShadow: `0 0 0 1px ${getColor(
            props.theme,
            `${props.colorScheme}.${props.colorMode === "light" ? 500 : 200}`
          )}`,
        },
      },
    }),
  },
};

export const chakraTheme = extendTheme(
  withDefaultColorScheme({ colorScheme: "purple" }),
  {
    initialColorMode: "dark",
    useSystemColorMode: true,
    components: {
      Input: inputStyle,
    },
    fonts: {
      heading: `Poppins, sans-serif`,
      body: `Poppins, sans-serif`,
      mono: `'Roboto Mono', monospace`,
    },
  }
);

export const App: FC = () => {
  return (
    <ChakraProvider theme={chakraTheme}>
      <BrowserRouter>
        <TabProvider>
          <TabInitializerCheck>
            <Layout>
              <Routes>
                <Route path="/" element={<InitPage />} />
                <Route path="/home" element={<HomePage />}>
                  <Route path=":id" element={<TabPage />} />
                </Route>
                <Route path="/settings/*" element={<SettingsPage />} />
              </Routes>
            </Layout>
          </TabInitializerCheck>
        </TabProvider>
      </BrowserRouter>
    </ChakraProvider>
  );
};

const TabInitializerCheck: FC<{ children: ReactElement }> = ({ children }) => {
  const tabs = useTabs();
  const isIndex = useMatch("/");

  // if context is null, suspend rendering until it is initialized
  if (tabs === null) return null;

  // if tabs are not initialized, redirect to init page.
  if (!tabs.isInitialized && !isIndex) return <Navigate to="/" />;

  return children;
};

export default App;
