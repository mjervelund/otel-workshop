import os

from langchain_community.callbacks import get_openai_callback
from langchain.callbacks.openai_info import OpenAICallbackHandler
from langchain.agents.structured_chat.prompt import SUFFIX
from langchain_core.output_parsers import StrOutputParser
from langchain.chains import ConversationChain
from langchain.agents import AgentExecutor, AgentType, initialize_agent
from langchain_openai import AzureChatOpenAI
from langchain.memory import ConversationBufferMemory

from personas.persona import Persona

import chainlit as cl


AZURE_OPENAI_CHAT_DEPLOYMENT_VERSION = os.getenv("AZURE_OPENAI_CHAT_DEPLOYMENT_VERSION")


class Chat(Persona):
    async def on_chat_start(self, agent_settings=None):

        settings = await cl.ChatSettings(agent_settings).send()      
        await self.on_settings_update(settings)
        await cl.Message(content="Hello! I'm here to chat with you about anything you want!").send()


    async def on_settings_update(self, settings):
        print("Setup agent with following settings: ", settings)

        llm = AzureChatOpenAI(
            temperature=settings["Temperature"],
            deployment_name=settings["Model"],
            streaming=settings["Streaming"],
            api_version=AZURE_OPENAI_CHAT_DEPLOYMENT_VERSION,
            callbacks=[OpenAICallbackHandler()]
        )
        self.chain = ConversationChain(
            llm=llm,
            output_parser=StrOutputParser(),
            callbacks=[OpenAICallbackHandler()],
        )
        
    async def on_message(self, message: cl.Message):
        output_message = cl.Message(content="")

        with get_openai_callback() as cb:
            result = self.chain.invoke({ "input": message.content })
            output_message.content = result["response"]
            print(cb)
            # tokens = cb.total_tokens

        await output_message.send()
        # await cl.Message(content=f"You spent {tokens} tokens").send()
