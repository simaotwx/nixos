from typing import Optional
from mcp.server.fastmcp import FastMCP
import subprocess

mcp = FastMCP("HelloWorld")

@mcp.tool("fortune", "Tell a fortune")
def say_hello() -> str:
    return subprocess.run(["fortune"], stdout=subprocess.PIPE, text=True).stdout.strip()

mcp.run(transport="stdio")
