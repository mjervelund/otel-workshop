import os
import chainlit as cl

from dotenv import find_dotenv, load_dotenv
from langchain_community.vectorstores.chroma import Chroma
from langchain.chains import ConversationalRetrievalChain
from langchain.memory import ChatMessageHistory, ConversationBufferMemory
from langchain_openai import AzureChatOpenAI
from langchain_openai.embeddings import AzureOpenAIEmbeddings
from langchain.chains import VectorDBQA
from langchain_text_splitters import RecursiveCharacterTextSplitter
from sympy import true
from personas.persona import Persona


from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain.chains import create_retrieval_chain
from langchain import hub


load_dotenv(find_dotenv())


AZURE_OPENAI_CHAT_DEPLOYMENT_VERSION = os.getenv("AZURE_OPENAI_CHAT_DEPLOYMENT_VERSION")
AZURE_OPENAI_EMBEDDINGS_DEPLOYMENT = os.getenv("AZURE_OPENAI_EMBEDDINGS_DEPLOYMENT")

class Vector_Chat(Persona):

    @staticmethod
    def create_conversation_buffer():
        message_history = ChatMessageHistory()
        return ConversationBufferMemory(
            memory_key="chat_history",
            output_key="answer",
            chat_memory=message_history,
            return_messages=True
        )

    async def on_chat_start(self, agent_settings=None):

        settings = await cl.ChatSettings(agent_settings).send()      
        await self.on_settings_update(settings)
        await cl.Message(content="Hello! I'm Joann. I have access to the vector database and we can talk about them!").send()

    async def on_settings_update(self, settings):
        print("Setup agent with following settings: ", settings)

        llm = AzureChatOpenAI(
            temperature=settings["Temperature"],
            deployment_name=settings["Model"],
            streaming=settings["Streaming"],
            api_version=AZURE_OPENAI_CHAT_DEPLOYMENT_VERSION,
        )
        

        memory = self.create_conversation_buffer()
        
        embeddings = AzureOpenAIEmbeddings(deployment=AZURE_OPENAI_EMBEDDINGS_DEPLOYMENT, chunk_size=1, openai_api_type=AZURE_OPENAI_CHAT_DEPLOYMENT_VERSION)

        # Open chroma db
        collection_name = "telemetry_workshop"
        chromadb = Chroma(persist_directory="database/chroma_db", collection_name=collection_name, embedding_function=embeddings)

        # create a chain that uses the Chroma vector store
        self.chain = ConversationalRetrievalChain.from_llm(
            llm=llm,
            chain_type="stuff",
            retriever=chromadb.as_retriever(),
            memory=memory,
            return_source_documents=True,
            verbose=True
        )

    async def on_message(self, message):
        cb = cl.AsyncLangchainCallbackHandler()

        result = await self.chain.ainvoke(message.content, callbacks=[cb], verbose=True)
        answer = result["answer"]

        print(result)
        source_documents = result["source_documents"]

        text_elements = []

        print(source_documents)
        if source_documents:
            for source_idx, source_doc in enumerate(source_documents):
                source_name = source_doc.metadata.get('title','<No title>')
                url = source_doc.metadata.get('source','Unknown')
                source_content = f"**Source:** [{source_name}]({url}) \r\n **Content:** " + source_doc.page_content
                text_elements.append(cl.Text(content=source_content, name=source_name))

            source_names = [text_element.name for text_element in text_elements]

            if source_names:
                answer += f"\nSources: {', '.join(source_names)}"
            else:
                answer += "\nNo sources found."

        await cl.Message(content=answer, elements=text_elements).send()



