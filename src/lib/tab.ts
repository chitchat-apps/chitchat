import { v4 as uuid } from "uuid";

export class Tab {
  id: string;
  label: string;

  constructor(label: string) {
    this.label = label;
    this.id = uuid();
  }
}

export class ChannelTab extends Tab {
  channel: string;

  constructor(channel: string) {
    channel = channel.toLowerCase();
    super(channel);
    this.channel = channel;
  }
}

export enum TabType {
  Channel,
  Whisper,
  Mentions,
  Watching,
}
