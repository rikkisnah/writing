Below is a draft you can use directly in your SharePoint, then save as `./blogs/how-ai-models-work.md`.

***

# How Large Language Models Actually Work on OCI

Posted by: AI2 Compute Team | December 01, 2025

Modern “AI chatbots” feel magical when they write code, summarize incident reports, or debug Terraform plans from a single prompt. But under the hood, a large language model running on Oracle Cloud Infrastructure is just a very fast prediction engine running on GPUs. Understanding that simple idea matters for OCI engineers, because it shapes how we design GPU clusters, inference endpoints, and the services that sit on top of them. Once you see how these models work, the Generative AI Service and its APIs look much less like black boxes and much more like familiar distributed systems problems.[1][2][3][4]

## The Core Idea: A Prediction Engine, Not Magic

A large language model is a function that takes in a sequence of tokens and predicts the next token, over and over, until it has produced a complete answer. Tokens are just small chunks of text (often sub‑words) that are mapped to integer IDs and then to vectors of numbers, called embeddings, in a high‑dimensional space. At each step, the model looks at all the tokens it has seen so far and outputs a probability distribution over the next token, such as “there is a 40% chance the next token is ‘database’, 10% chance it is ‘cluster’, and so on.”[5][6][7]

When you use the OCI Generative AI Service, this prediction process is what powers text generation, chat completion, and summarization APIs. The service receives your prompt, tokenizes it, runs it through a transformer model, and then samples tokens from that probability distribution until it hits a stop condition such as a maximum number of tokens or an end‑of‑sequence marker. The concepts you control in the API—temperature, top‑p, maximum output tokens—are simply different ways of shaping that distribution and deciding how “creative” or conservative the next‑token choices should be.[2][3][4][8][1]

The transformer architecture at the heart of modern language models uses self‑attention to decide which parts of the input matter most for the current prediction. Instead of reading text strictly left to right like older recurrent networks, self‑attention lets every token “look at” every other token in the context and assign weights that say “focus more on this word, less on that one.” Stacked across many layers, this mechanism is what allows a model to keep track of long prompts, resolve pronouns correctly, and understand that “bank” means something very different in a financial report than in a river monitoring dataset.[6][7][9][5]

## How Training Works on OCI GPU Clusters

Training is where a language model learns its parameters; inference is where it uses those parameters to answer prompts. Training takes a huge corpus of text and repeatedly asks the model to predict the next token, then nudges its weights whenever it is wrong using gradient‑based optimization. You can think of this as the model repeatedly playing a fill‑in‑the‑blank game on trillions of tokens, gradually adjusting billions of weights so that its guesses get better and better.[7][5][6]

This learning process is extremely compute‑intensive, which is why large models are trained on GPU clusters with high‑bandwidth interconnects and fast storage. On OCI, the same primitives used for HPC and deep learning—GPU shapes, RDMA networks, block volumes, and object storage—form the foundation for training and fine‑tuning generative models. The OCI Generative AI Service provides managed, pre‑trained language models from partners like Cohere and Meta, and also supports fine‑tuning with your own data on dedicated AI clusters in your tenancy. In that fine‑tuning scenario, your domain‑specific dataset is used to continue the next‑token prediction training process, updating weights so the model becomes better at tasks like support ticket summarization or industry‑specific question answering.[3][8][10][1][2][7]

From an infrastructure perspective, training is about scheduling large, multi‑node jobs that saturate GPUs, managing distributed checkpoints, and keeping I/O pipelines fed with tokenized data. While base model pre‑training is typically done by model providers, OCI engineers still care deeply about training mechanics because the same cluster management patterns apply to fine‑tuning workloads, evaluation pipelines, and internal research experiments using the Generative AI stack.[8][2][3]

## How Inference Works When You Call an Endpoint

Inference is the part most OCI users touch directly: calling an endpoint to turn a prompt into a response. When your application sends a request to an OCI Generative AI endpoint, the service first authenticates the call and routes it to a model deployment running on GPUs in an OCI region. The prompt is tokenized into IDs, batched with other requests when possible, and then passed through the transformer model to compute the next‑token probabilities.[4][1][2][3][5][6][7]

For each generated token, the service applies your decoding settings (temperature, top‑p, stop sequences) and either chooses the single most likely token or samples from the distribution. This token is appended to the sequence, fed back into the model, and the process repeats until the service hits your maximum output tokens or one of the stop conditions. The generated tokens are then converted back into text and streamed to the caller if you requested a streaming response.[1][2][4][8]

Behind a single API call, inference involves provisioning and scaling GPU capacity, managing model weights in memory, batching requests for throughput, and enforcing tenancy isolation. The managed nature of OCI Generative AI means clients see a simple HTTPS endpoint, while the service coordinates autoscaling, health checks, logging, and integration with Identity and Access Management.[11][2][3][1]

## Practical OCI Example: Basic Text Generation in Python

The following snippet shows a simplified Python example using the OCI SDK to call the Generative AI Service for basic text generation. Exact class names and parameters may vary by SDK version, so treat this as pseudocode aligned with the current documentation.[3][4][1]

```python
import oci

# Create a config from your OCI CLI profile or config file
config = oci.config.from_file("~/.oci/config", "DEFAULT")

# Initialize the Generative AI client
genai_client = oci.generative_ai.GenerativeAiClient(config)

prompt = "Summarize this incident ticket for an executive audience in 3 sentences."

request_body = {
    "modelId": "cohere.command-r-plus",   # Example model identifier
    "input": prompt,
    "maxTokens": 256,
    "temperature": 0.3,
    "topP": 0.9
}

response = genai_client.generate_text(
    generate_text_details=request_body
)

print("Model output:")
print(response.data.output_text)
```

In this example, the only things you provide are configuration, a model identifier, and a prompt. The Generative AI Service handles tokenization, batching, running the transformer on GPUs, and streaming back the generated tokens as a final string. If you lower the temperature, the model becomes more deterministic; if you increase it, you will see more variation in the generated summaries because the sampling over next‑token probabilities becomes less conservative.[2][4][8][1][3]

## Practical OCI Example: Inspecting the Request and Response Shape

To demystify the “magic,” it helps to look at the structure of the request and response objects that travel over the wire. The following code sketches a chat‑style interaction where you send a list of messages and receive a structured response that includes both the output text and metadata.[4][1][3]

```python
chat_request = {
    "modelId": "cohere.command-r-plus",
    "messages": [
        {"role": "system", "content": "You are an OCI expert assistant."},
        {"role": "user", "content": "Explain how a large language model works in simple terms."}
    ],
    "maxTokens": 300,
    "temperature": 0.4
}

chat_response = genai_client.chat(
    chat_details=chat_request
)

print("Full response object:")
print(chat_response.data)

print("\nAssistant reply:")
print(chat_response.data.choices[0].message.content)
```

The request object simply describes the model to use, the conversation history, and a few generation parameters. The response object contains one or more choices that hold the assistant’s generated message, along with metadata such as token counts that can be used for observability, cost tracking, and latency analysis. Conceptually, nothing mystical is happening between the request and the response: the service is repeatedly running “predict next token given this context” on your behalf, then packaging the results into a convenient JSON structure.[1][2][3][4]

From an OCI engineer’s point of view, you can treat these endpoints like any other internal platform service: protect them with IAM policies, route traffic through private endpoints, monitor them with logging and metrics, and integrate them into existing CI/CD and deployment pipelines. The difference is that instead of returning simple CRUD results, they return synthesized text generated by a very large function learned from data.[11][2][3][1]

## Conclusion: Tying the Model Back to the Infrastructure

Thinking of a large language model as a next‑token prediction engine clarifies both the math and the infrastructure requirements. Training is about using massive GPU clusters and distributed storage to adjust billions of parameters so the model becomes good at predicting tokens across many domains. Inference is about hosting those trained weights efficiently and reliably, then exposing them through predictable endpoints that fit into existing application stacks.[7][8][2][3][4][1]

OCI provides the layers that make this usable at scale: GPU shapes and networking at the bottom, managed Generative AI Service and dedicated AI clusters in the middle, and higher‑level integrations like Select AI in Autonomous Database and application frameworks on top. For OCI engineers, understanding how the models work helps when designing capacity plans, debugging latency issues, building guardrails, or explaining behavior to application teams that are trying to adopt generative AI safely. The underlying mechanics are surprisingly simple: turn text into tokens, run a transformer with self‑attention, and predict the next token; OCI’s job is to make that simple building block reliable, secure, and fast for every workload that depends on it.[12][5][6][8][2][3][1]

***

## References

1. Oracle Help Center – Generative AI Service Overview. https://docs.oracle.com/en-us/iaas/Content/generative-ai/overview.htm[1]
2. Oracle Help Center – Generative AI Documentation Home. https://docs.oracle.com/en-us/iaas/Content/generative-ai/home.htm[3]
3. Oracle Help Center – Using the Large Language Models in Generative AI. https://docs.public.content.oci.oraclecloud.com/en-us/iaas/Content/generative-ai/use-playground.htm[4]
4. Oracle Solutions – Implement OCI Generative AI Based on Large Language Models. https://docs.oracle.com/en/solutions/oci-generative-ai-llm/index.html[2]
5. Oracle Help Center – Examples of Using Select AI. https://docs.oracle.com/en-us/iaas/autonomous-database-serverless/doc/select-ai-examples.html[13]
6. Anthropic – Technical Overview of Claude Models (blog / documentation). https://www.anthropic.com/news   
7. OpenAI – GPT Model Technical Overview and Documentation. https://platform.openai.com/docs/introduction   
8. IBM – What is an Attention Mechanism? https://www.ibm.com/think/topics/attention-mechanism[9]
9. DataCamp – How Transformers Work: A Detailed Exploration of the Transformer Architecture. https://www.datacamp.com/tutorial/how-transformers-work[7]

#AIFundamentals #OCI #GenerativeAI #AI2Compute

[1](https://docs.oracle.com/en-us/iaas/Content/generative-ai/overview.htm)
[2](https://docs.oracle.com/en/solutions/oci-generative-ai-llm/index.html)
[3](https://docs.oracle.com/en-us/iaas/Content/generative-ai/home.htm)
[4](https://docs.public.content.oci.oraclecloud.com/en-us/iaas/Content/generative-ai/use-playground.htm)
[5](https://magnimindacademy.com/blog/the-mechanism-of-attention-in-large-language-models-a-comprehensive-guide/)
[6](https://poloclub.github.io/transformer-explainer/)
[7](https://www.datacamp.com/tutorial/how-transformers-work)
[8](https://www.infolob.com/defining-essential-components-of-oci-generative-ai/)
[9](https://www.ibm.com/think/topics/attention-mechanism)
[10](https://jvikraman.com/blog/oci-gen-ai-notes)
[11](https://docs.public.content.oci.oraclecloud.com/en-us/iaas/digital-assistant/doc/llm-services.html)
[12](https://blogs.oracle.com/machinelearning/announcing-oracle-adb-select-ai-for-text-translation-and-summarization)
[13](https://docs.oracle.com/en-us/iaas/autonomous-database-serverless/doc/select-ai-examples.html)