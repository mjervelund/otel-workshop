import chainlit as cl

from personas.chat import Chat
from personas.vector_chat import Vector_Chat

from typing import Dict, Optional
from langchain.memory import ConversationBufferMemory
from dotenv import load_dotenv, find_dotenv

from chainlit.input_widget import Select, Switch, Slider

from fastapi import FastAPI
import os


load_dotenv(find_dotenv())

@cl.cache
def get_memory():
    persona = cl.user_session.get("persona")

    get_memory = getattr(persona, "get_memory", None)
    if persona and callable(get_memory):
        return persona.get_memory()     
    else:
        return ConversationBufferMemory(memory_key="chat_history")




@cl.set_chat_profiles
async def chat_profile():
    return [
        cl.ChatProfile(
            name="chat",
            markdown_description="I'll chat with you about anything you want!",
        ),
        cl.ChatProfile(
            name="GPT + Internal Knowledge",
            markdown_description="I have access to documentation and we can talk about it!",
        )
    ]


def get_settings():
    return [
            Select(
                id="Model",
                label="OpenAI - Model",
                values=["gpt-4o"],
                initial_index=0,
            ),
            Switch(id="Streaming", label="OpenAI - Stream Tokens", initial=True),
            Slider(
                id="Temperature",
                label="OpenAI - Temperature",
                initial=0.5,
                min=0,
                max=1,
                step=0.1,
            )
        ]

@cl.on_chat_start
async def on_chat_start():
    persona = None
    chat_profile = cl.user_session.get("chat_profile")
    if chat_profile == "GPT":
        persona = Chat()
    elif chat_profile == "GPT + Internal Knowledge":
        persona = Vector_Chat()


    if persona:
        await persona.on_chat_start(agent_settings=get_settings())
        cl.user_session.set("persona", persona)
    else:
        await cl.Message(content=f"starting chat using the {chat_profile} chat profile").send()

@cl.on_settings_update
async def on_settings_update(settings):
    persona = cl.user_session.get("persona")
    on_settings_update = getattr(persona, "on_settings_update", None)
    if persona and callable(on_settings_update):
        await persona.on_settings_update(settings)     
    else:
        pass

@cl.on_message
async def on_message(message: cl.Message):
    persona = cl.user_session.get("persona")
    if persona:
        await persona.on_message(message)
    else:
        await cl.Message(content=f"received message in {chat_profile} chat profile").send()


# @cl.oauth_callback
# def oauth_callback(
#   provider_id: str,
#   token: str,
#   raw_user_data: Dict[str, str],
#   default_user: cl.User,
# ) -> Optional[cl.User]:
#   return default_user


@cl.password_auth_callback
def auth_callback(username: str, password: str):
    # Fetch the user matching username from your database
    # and compare the hashed password with the value stored in the database
    if (username, password) == ("admin", "admin"):
        return cl.User(
            identifier="admin", metadata={"role": "admin", "provider": "credentials"}
        )
    else:
        return None


if __name__ == "__main__":
    from chainlit.cli import run_chainlit
    run_chainlit(__file__)
