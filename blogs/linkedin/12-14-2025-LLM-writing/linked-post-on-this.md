# LinkedIn Post: TOON and MCP for Token Optimization

## Original Post

**Dennis Fanshaw**  
Network nerd • 3 hours ago (edited)

---

I play what a lot of folks would describe as a "spreadsheet with timers" game. Think an idler like [Universal Paperclips](https://lnkd.in/eA9EUuwq), but instead of clicking things, you're making decisions off multiple data streams (spreadsheets) that change over time (timers); think market data and order books, or route optimization for manufacturing logistics.

The game exposes a REST API with a Swagger spec, so yesterday I used that as an excuse to sit down with Claude Code and spin up an MCP for the API.

I learned a lot about MCP in the process. Claude Code does a surprisingly good job going from Swagger spec + described use cases to a usable MCP server quickly. The code it produced helped solidify for me both how MCP actually works in practice, and how simple and powerful it can be.

Somewhere during the exercise, TOON also clicked.

It happened when I noticed how bloated my context was, and how many tokens my chats were burning. Chaining the MCP tools together was consuming a lot of tokens, largely because semi-structured data was getting passed between tools via context. There are ways around this, but sometimes you need that data in-context.

That's where TOON comes in.

TOON compresses structured data to reduce the number of tokens required to represent it. If you've ever minified JavaScript to reduce download time, you already mostly get the idea; same data, more compact encoding, optimized for a different consumer.

TOON is basically minification for AI context: compact, intentional structure that preserves meaning while cutting context size and token spend.

Good TOON reference here: https://lnkd.in/eTjBY5M4

And if you're a goblin space merchant using AI… "tokens are money, fren." 💰

Tip o'the hat to John Capobianco who was the first to bring TOON to my attention.

---

## Comments

### Rik Kisnah
**Senior Principal Engineer (HPC/GPU) at Oracle Cloud Infrastructure (OCI) for AI/ML Infrastructure** • 1 hour ago

Thanks for sharing — very timely.

This landed right as we were having an AI conference in Seattle at my employer, where a recurring theme was treating Markdown as a first-class citizen in development workflows. The motivation was exactly this: controlling context size, reducing token burn, and making structure explicit for both humans and models. TOON seems to fit cleanly into that narrative. It's the same principle applied one level deeper — intentional, compact representations of structured data, optimized for model consumption rather than human readability. Less noise, same semantics, lower cost.

The analogy to minification is interesting. If tokens are money, then maybe TOON (and Markdown-first design) are just good engineering hygiene. TOON is so catchy — reminds me of cartoons which I used to watch every Sunday after church.

---

### Rik Kisnah (Follow-up)
**Senior Principal Engineer (HPC/GPU) at Oracle Cloud Infrastructure (OCI) for AI/ML Infrastructure**

Also, if you aren't already, talk to some of your brothers and sisters in NDE land in phynet about some of the structured data they use in their day-to-day workflows to represent their environments. Likely some intersection/easy wins there as well.
