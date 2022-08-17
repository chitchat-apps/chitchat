import { invoke, event } from "@tauri-apps/api";
import { Button, Icon, Text, VStack } from "@chakra-ui/react";
import { FC, useEffect, useState } from "react";
import { FiTwitch } from "react-icons/fi";
import useAuth from "../../hooks/useAuth";

const UserPage: FC = () => {
  const auth = useAuth();

  const [enabled, setEnabled] = useState(false);

  const handleLogin = async () => {
    setEnabled(true);
    await invoke("request_login");
  };

  useEffect(() => {
    event.once<string>("token", async (ev) => {
      const token = ev.payload;
      try {
        if (token) {
          const res = await fetch("https://id.twitch.tv/oauth2/validate", {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          });
          if (!res.ok) throw new Error("Invalid token");
          const data = await res.json();
          auth.login(token, data.login);
        }
      } catch (error) {
        console.log(error);
      } finally {
        setEnabled(false);
      }
    });
  }, []);

  return (
    <VStack w="100%" h="100%" align="center" justify="center" spacing={0}>
      <VStack spacing={0} align="start">
        {(enabled || auth.isLoading) && (
          <Text textAlign="center" mb={1}>
            Logging in.
            <br />
            Please keep this page open.
          </Text>
        )}
        {auth.isAuthenticated ? (
          <>
            <Text pb={3}>
              Logged in as&nbsp;
              <Text as="span" fontWeight="bold">
                {auth.username}
              </Text>
            </Text>
            <Button onClick={auth.logout}>Logout</Button>
          </>
        ) : (
          <Button
            isLoading={enabled}
            leftIcon={<Icon as={FiTwitch} />}
            onClick={handleLogin}
          >
            Sign in with Twitch
          </Button>
        )}
      </VStack>
    </VStack>
  );
};

export default UserPage;
