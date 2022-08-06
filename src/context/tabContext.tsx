import { createContext, FC, ReactNode, useEffect, useState } from "react";
import { ChannelTab, Tab } from "../lib/tab";

export interface ITabContext {
  isInitialized: boolean;
  tabs: Tab[];
  addTab: (tab: Tab) => void;
  saveTab: (tab: Tab) => void;
  updateTab: (id: string, tab: Tab) => void;
  removeTab: (id: string) => void;
  loadTabs: () => string | null;
}

export const TabContext = createContext<ITabContext | null>(null);

const TabProvider: FC<{
  children: ReactNode;
}> = ({ children }) => {
  const [isInitialized, setIsInitialized] = useState(false);
  const [tabs, setTabs] = useState<Tab[]>([]);

  const loadTabs = () => {
    const tabs = localStorage.getItem("tabs");
    const activeTab = localStorage.getItem("activeTab");
    if (tabs) {
      const tabList = JSON.parse(tabs) as Tab[];
      const tabListWithClasses = tabList.map((tab) => {
        if ("channel" in tab) {
          const t = new ChannelTab((tab as ChannelTab).channel);
          t.id = tab.id;
          return t;
        }
        return tab;
      });
      setTabs(tabListWithClasses);
    }
    setIsInitialized(true);
    return activeTab;
  };

  const saveTabs = (tabs: Tab[]) => {
    localStorage.setItem("tabs", JSON.stringify(tabs));
  };

  const addTab = (tab: Tab) => {
    setTabs([...tabs, tab]);
  };

  const saveTab = (tab: Tab) => {
    const newTabs = tabs.map((t) => (t.id === tab.id ? tab : t));
    setTabs(newTabs);
  };

  const updateTab = (id: string, tab: Tab) => {
    tab.id = id;
    const newTabs = tabs.map((t) => (t.id === id ? tab : t));
    setTabs(newTabs);
  };

  const removeTab = (id: string) => {
    setTabs(tabs.filter((tab) => tab.id !== id));
  };

  useEffect(() => {
    isInitialized && saveTabs(tabs);
  }, [tabs, isInitialized]);

  return (
    <TabContext.Provider
      value={{
        isInitialized,
        tabs,
        addTab,
        removeTab,
        saveTab,
        updateTab,
        loadTabs,
      }}
    >
      {children}
    </TabContext.Provider>
  );
};

export default TabProvider;
