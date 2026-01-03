
### SICA Podcast – OCI GPUs & Customers

**Speakers:**

* Speaker 4 – Rik
* Speaker 1 – John
* Speaker 3 – Arnaud
* Speaker 2 – Oguz
* Speaker 5 – Bob

---

**[Speaker 4 - Rik]**
Good morning, OCI GPU citizens. Welcome to yet another SICA podcast. Today, we have three special guests.

Bob and I are honored to welcome them. Many of us have been friends for more than a decade. We started together at Verigreen, learning about HPC, and today we’re working together in GPUs.

Joining us are three amazing friends and architects from the Strategic Accounts and Solutions Architecture teams: the famous John Shelley, the renowned French Arnaud Faudemoy, and another good friend of mine, Oguz. These three are in customer conversations every single day, and it's a brilliant opportunity to hear their perspective.

That’s why today we invited this trinity of architects.
Good morning, John.
Good morning, Arnaud.
Good morning, Oguz.

Thank you for being here. To start, could each of you introduce yourselves to the OCI GPU community—your role, your organization, and your mission to help grow our impact (and our RSUs) in the world of AI/ML?

John, let’s start with you.

---

**[Speaker 1 – John]**
Sure. Hi, I’m John Shelley. I’m part of the Strategic Customer Engineering team.

Our mission is to work with our largest AI customers—to understand what they’re doing today, what they plan to do in the future, advocate for them back to engineering, and help them successfully navigate OCI. There are many services and challenges, and our role is to help customers succeed end to end.

---

**[Speaker 4 - Rik]**
That’s brilliant, John. Thank you.

And my dear French friend—whom I've been teasing for the last ten years—Arnaud, what do you do?

---

**[Speaker 3 – Arnaud]**
Not much. I mostly try to look busy.

I’m Arnaud. I’m on the North America Solutions Architecture team focused on GPUs. We handle nearly every GPU customer except the ones John is responsible for.

In addition to what John said, our focus is scale. Our team doesn’t manage four or five large accounts—we manage the next 100 to 150. Many of these customers are AI startups who barely know how to SSH into a node. Our goal is to make them successful running AI/ML workloads on Oracle GPUs.

---

**[Speaker 4 - Rik]**
Merci beaucoup, Arnaud. Thank you.

Oguz, what about you? I believe you and Arnaud are on the same team, reporting into Pincash and Sachin.

---

**[Speaker 2 – Oguz]**
Yes, we’re on the same team reporting to Pincash.

Arnaud gave a great summary. Our goal is to help customers have the best possible experience running workloads on OCI. We provide tooling, solutions, and hands-on support—from day one and throughout their entire lifecycle on OCI.

---

**[Speaker 4 - Rik]**
So essentially, you’re the foundation that ensures what engineering builds turns into a crisp customer experience—and ultimately, revenue.

Here's a question: John, your mission sounds very similar to Arnaud and Oguz's. What's the difference between your groups?

John, maybe start, and then Oguz can add his perspective.

---

**[Speaker 1 – John]**
The primary difference is scale, specifically annual consumption rate—ACR.

We typically work with customers spending $100–200 million annually. As customers grow, we reassess whether they become strategic accounts. Oguz and Arnaud focus on customers below that threshold.

At the end of the day, if Larry says, “Go take care of them,” then we do.

---

**[Speaker 4 - Rik]**
Got it. So we have to be nicer to you than to Arnaud and Oguz, I guess.

---

**[Speaker 3 – Arnaud]**
What John didn’t say is that he only looks at ACR. We look at margin.

All of John’s customers barely make money. We’re the ones bringing in real profit.

---

**[Speaker 4 - Rik]**
Thank you, Arnaud.

---

**[Speaker 5 – Bob]**
So what I’m hearing is that John has one customer, and Arnaud and Oguz have hundreds. Is that right?

---

**[Speaker 1 – John]**
Not exactly. We have fewer than 100 strategic accounts, and not all of them are high ACR yet.

But if you look at total AI infrastructure spend, our accounts represent about 80% of the ACR. That’s the key difference.

---

**[Speaker 3 – Arnaud]**
We joke around, but in reality there’s a lot of overlap. Both teams often engage with the same customers.

Ultimately, it doesn’t matter who helps—as long as the customer succeeds.

---

**[Speaker 2 – Oguz]**
And when there’s a problem, it usually affects everyone regardless of size. We work closely together to fix what’s broken.

---

**[Speaker 1 – John]**
Absolutely. We constantly reach out to each other to share patterns and lessons learned. It’s a strong partnership.

---

**[Speaker 5 – Bob]**
Teamwork makes the dream work.

You mentioned ACR earlier. What does ACR stand for?

---

**[Speaker 1 – John]**
Annual Consumption Rate—how much a customer spends per year on OCI services.

Typically, customers with fewer than 1,000 GPUs don’t fall under Strategic Accounts, unless they’re growing rapidly.

---

**[Speaker 5 – Bob]**
John, in one minute: what differentiates OCI GPUs when customers compare clouds?

---

**[Speaker 1 – John]**
First, we offer bare metal. Other clouds rely heavily on virtualization, which reduces available memory and CPU and adds complexity through SR-IOV and passthrough. With OCI, customers get the entire system with full control—no hypervisor underneath.

Second, networking. I came from Azure believing RoCE was bad and InfiniBand was great. After testing OCI's RoCE, I was amazed at how comparable it is in performance and ease of use. RoCE also scales better than InfiniBand and benefits from Ethernet's faster evolution—like 800G NICs arriving sooner.

Finally, access to experts. Having Arnaud, Oguz, and myself directly engaged makes a huge difference.

---

**[Speaker 5 – Bob]**
Why does RoCE scale better than InfiniBand?

---

**[Speaker 1 – John]**
It’s architectural. InfiniBand relies on proprietary fabric managers, primarily tied to NVIDIA/Mellanox, which limits scale.

---

**[Speaker 5 – Bob]**
And was OCI’s RoCE architecture developed internally?

---

**[Speaker 1 – John]**
Yes. Jag Prar, an IC7 at OCI, led much of that work. We even named JFAB after him—Jag’s Fabric.

GFAB is the GPU fabric, and QFAB is the QoS fabric. Our RoCE networks run on GFAB and QFAB.

---

**[Speaker 5 – Bob]**
Arnaud, who’s running the biggest or most complex GPU workloads on OCI, and what are they doing?

---

**[Speaker 3 – Arnaud]**
There are three main workload types.

First, large-scale AI training—thousands of GPUs. These are fragile: one node failure or cable flap can stop the entire run.

Second, inference. It’s generally easier, often single-node, and we get fewer support calls.

Third, emerging workloads like healthcare (more traditional HPC) and robotics, which are growing quickly.

Across all of them, storage is critical. GPUs need data—fast object storage, Lustre, FSS. Data throughput is often the real bottleneck.

---

**[Speaker 5 – Bob]**
Are you seeing more GPU usage for training or inference?

---

**[Speaker 3 – Arnaud]**
Mostly training on OCI. Inference tends to be simpler and requires less infrastructure involvement.

---

**[Speaker 5 – Bob]**
And inference is less impacted by link failures?

---

**[Speaker 3 – Arnaud]**
Correct. Inference usually doesn’t use RDMA and often runs on a single node, frequently in Kubernetes.

---

**[Speaker 5 – Bob]**
Oguz, what do customers struggle with most every week?

---

**[Speaker 2 – Oguz]**
First, customers treat hardware failures as exceptional. At scale, they're not. I recommend the *Revisiting Reliability in Large-Scale Machine Learning Research Clusters* paper. With 500 GPUs, failures happen every few days. With 16,000 GPUs, failures are expected in every job. Customers need automated repair, checkpointing, and fault tolerance built into workloads.

Second, storage. GPUs without a solid data pipeline sit idle. Storage design must be first-class, not an afterthought.

---

**[Speaker 5 – Bob]**
What is OCI doing to help customers with these failures?

---

**[Speaker 2 – Oguz]**
It starts with health checks—passive and active—and smart auto-remediation. The challenge is balance: fixing issues without overreacting. Sometimes you reboot. Sometimes you reset GPUs. Sometimes you degrade performance but keep workloads running. The goal is resilience without interruption.

---

**[Speaker 5 – Bob]**
We'll share the links Oguz mentioned in the SICA blog and documentation for DR-HPC v2: https://bitbucket.oci.oraclecorp.com/projects/CCCP/repos/oci-dr-hpc-v2/browse.

---

**[Speaker 4 – Rik]**
Listening to this has been humbling. As engineers, we don’t always see what customers experience.

I’ll echo our leadership—Avnish Chhabra and Sudha—it’s a privilege to work here.

In one or two sentences: what excites you most about OCI, and where do you see us in the next 6–12 months?

Oguz?

---

**[Speaker 2 – Oguz]**
We get access to the latest GPUs before anyone else. That's how you learn—by breaking things on real hardware. The multi-planar network excites me most. Disjoint planes mean failures degrade performance but don't stop workloads. That's a game changer.

---

**[Speaker 4 – Rik]**
Thank you.

Arnaud—besides French wine—what excites you?

---

**[Speaker 3 – Arnaud]**
Five years ago, our first deal was tiny. Now we're closing deals 1,000× larger. Customers constantly push limits, and we keep breaking and redesigning OCI. It's fun. We're also building great tooling—Kubernetes stacks, Slurm clusters—that let customers go from zero to PyTorch in under an hour.

---

**[Speaker 4 – Rik]**
Thank you.

John, what excites you?

---

**[Speaker 1 – John]**
When I joined, we had three strategic AI customers. Now we're deploying GFABs multiple times per year. We're talking 128,000-GPU clusters with multi-planar designs. The pace is unbelievable. We're bleeding, learning, and having fun—and pushing compute, network, and storage to new limits.

---

**[Speaker 4 - Rik]**
It's emotional listening to you all. John, Arnaud, Oguz—thank you. It's a privilege to work with you and to learn from your customer insights. You help us build real products, not marketing gimmicks. On behalf of AI2 Compute: thank you.

---

