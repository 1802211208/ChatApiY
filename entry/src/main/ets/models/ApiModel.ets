export interface ApifoxModel {
  frequency_penalty?: number;
  logit_bias?: null;
  max_tokens?: number;
  messages: ChatMessage[];
  model: string;
  n?: number;
  presence_penalty?: number;
  stream?: boolean;
  temperature?: number;
  top_p?: number;
  user?: string;
}

export interface ChatMessage {
  role: string;
  content: string | MessageContent[];
}

export interface MessageContent {
  type: 'text' | 'image_url';
  text?: string;
  image_url?: ImageUrl;
}

export interface ImageUrl {
  url: string;
}

interface GeneratedTypeLiteralInterface_1 {
  message: ChatMessage;
  finish_reason: string;
  index: number;
}

export interface ApiResponse {
  choices: Array<GeneratedTypeLiteralInterface_1>;
}
export interface ApiResponseError {
  error: ApiResponseErrorObj;
}
export interface ApiResponseErrorObj {
  message: string;
  code: string;
}


export interface ModelResponse {
  data: Model[];
  object: string;
}

export interface Model {
  id: string;
  object: string;
  created: number;
  owned_by: string;
  root: string;
  parent: string | null;
}

interface StreamChunkDelta {
  content?: string;
  role?: string;

}

interface StreamChunkChoices {
  index: number;
  delta: StreamChunkDelta;
  logprobs: null;
  finish_reason: null | string;
}

export interface StreamChunk {
  id: string;
  object: string;
  created: number;
  model: string;
  system_fingerprint: string;
  choices: Array<StreamChunkChoices>;
}
export interface Chat {
  id: string;
  title: string;
  lastMessage?: string;
  createTime: number;
  updateTime: number;
  messages: ChatMessage[];
}


