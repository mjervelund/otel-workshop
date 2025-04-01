import chainlit as cl

import os
from langchain.indexes import SQLRecordManager, index
from langchain_openai import AzureOpenAIEmbeddings
from langchain_text_splitters import Language, RecursiveCharacterTextSplitter
from langchain_community.document_loaders import UnstructuredMarkdownLoader
from langchain_core.documents import Document
from langchain_community.document_loaders import DirectoryLoader
from pathlib import Path
# https://python.langchain.com/docs/integrations/vectorstores/chroma/
from langchain_community.vectorstores.chroma import Chroma
# from tools/add_to_index.py

from dotenv import load_dotenv, find_dotenv

from fastapi import FastAPI

load_dotenv(find_dotenv("../.env"))

AZURE_OPENAI_CHAT_DEPLOYMENT_VERSION = os.getenv("AZURE_OPENAI_CHAT_DEPLOYMENT_VERSION")
AZURE_OPENAI_CHAT_DEPLOYMENT = os.getenv("AZURE_OPENAI_CHAT_DEPLOYMENT_NAME")
AZURE_OPENAI_EMBEDDINGS_DEPLOYMENT = os.getenv("AZURE_OPENAI_EMBEDDINGS_DEPLOYMENT")


print("✨ Initialising Azure OpenAI Embeddings")
embeddings = AzureOpenAIEmbeddings(deployment=AZURE_OPENAI_EMBEDDINGS_DEPLOYMENT, chunk_size=1, openai_api_type=AZURE_OPENAI_CHAT_DEPLOYMENT_VERSION)
embedding_function=embeddings.embed_query

collection_name = "telemetry_workshop"


print("✨ Initialising vector dbs: Chroma")
chromadb = Chroma(persist_directory="database/chroma_db", collection_name=collection_name, embedding_function=embeddings)


namespace = f"cromadb/{collection_name}"
record_manager = SQLRecordManager(
    namespace, db_url="sqlite:///record_manager_cache.sql"
)

record_manager.create_schema()

text_splitter = RecursiveCharacterTextSplitter.from_language(language=Language.MARKDOWN, chunk_size=4000, chunk_overlap=0)


loader = DirectoryLoader("data", glob="**/*.md", silent_errors=True)
docs = loader.load()
index(doc,record_manager, chromadb, cleanup='incremental', source_id_key='source')

chromadb.persist()
