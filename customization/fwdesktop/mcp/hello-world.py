from typing import Optional
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("HelloWorld")

@mcp.resource("greeting://{name}")
def get_greeting(name: Optional[str]) -> str:
    return f"Hello, {name or "World"}!"

@mcp.tool("say_hello", "Greets the user or the world")
def say_hello(name: Optional[str]) -> str:
    return f"Hello, {name or "World"}!"

mcp.run(transport="stdio")
