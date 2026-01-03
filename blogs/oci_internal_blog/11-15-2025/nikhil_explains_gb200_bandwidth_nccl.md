rkisnah
New hire:wave:  Mar 31st at 21:25
Hey @gb200-ninjas, @ngshetty, @aiazzag, @sirampur —
We just wrapped up the first OCI cross-rack testing for InfiniBand using both NCCL and IB Write benchmarks. Full details here: https://confluence.oraclecorp.com/confluence/pages/viewpage.action?pageId=14717735599
TL;DR Results:
ib-write-bw: 385 Gb/s
NCCL (IB + NVLink, AllReduce, 16G message): 778 GB/s
:rocket: This is a major milestone.
We’ve demonstrated that the UFM stack from Dr. Shetty and Sid can operate at scale (well, almost :smile:) without any erratic behavior.
 We’ve also shown that cross-rack over InfiniBand is no longer just a POC — it runs at scale.
Huge thanks to the Ai2-COM GB200 crew for the intense push over the last 4 days — especially @niharish, @ytsagar, @kevinlu and @juewan. Stellar work! :raised_hands: (edited) 
:yay-frog:
12
:hero:
4
:clapping:
3
:ocichampion:
1






44 replies
aiazzag
:no_entry:  Apr 1st at 07:32
Hey Rik,
Is all-to-all still failing ? I see that in the confluence
rkisnah
New hire:wave:  Apr 1st at 07:32
yes we have a tix with nvidia  https://partners.nvidia.com/Bug/ViewBug/5196566
aiazzag
:no_entry:  Apr 1st at 07:33
Is the customer aware ? This means if their workload contains all-to-all communication it'll fail ?
rkisnah
New hire:wave:  Apr 1st at 07:33
Our senior leadership are aware.
:ack:
1

aiazzag
:no_entry:  Apr 1st at 07:33
Ack, I also see ~136g for infiniband communication , is that expected ? (edited) 
gsiekas
:no_entry:  Apr 1st at 07:34
To be clear alltoall was hanging at scale
:ack:
1

gsiekas
:no_entry:  Apr 1st at 07:34
And showing incorrect output for the message size
gsiekas
:no_entry:  Apr 1st at 07:34
As we increased the number of nodes the output error shifted to higher message sizes.
:jp-yes:
1

aiazzag
:no_entry:  Apr 1st at 07:35
Interesting
aiazzag
:no_entry:  Apr 1st at 07:35
so it may be a problem with the NCCL benchmark ?
rkisnah
New hire:wave:  Apr 1st at 07:35
Ack, I also see ~136g for infiniband communication , is that expected ?
I don't know.. Might need your help or nikhil to figure out what is expected. For the results published - i don't have a good working / mathematical model/idea what the baseline should be. (edited) 
rkisnah
New hire:wave:  Apr 1st at 07:36
so it may be a problem with the NCCL benchmark ?
Yes that is one thread we were looking if the nccl-test we took from github is older that the current one. (edited) 
aiazzag
:no_entry:  Apr 1st at 07:44
https://techcommunity.microsoft.com/blog/azurehighperformancecomputingblog/unpacking-the-p[…]b200-v6-virtual-machines/4390442
Is it me or are we crushing Microsoft's numbers for NVLINK ? They are saying :
The ND GB200 v6’s NVLink achieved a bandwidth of approximately 680 GB/s,
I see we get up to ~780 GB/s in all-reduce through NVLINK
gsiekas
:no_entry:  Apr 1st at 07:52
We are getting > 900GB/s at higher message sizes.
:star-struck:
1

aiazzag
:no_entry:  Apr 1st at 08:04
I don't know.. Might need your help or nikhil to figure out what is expected. For the results published - i don't have a good working / mathematical model/idea what the baseline should be. (edited)
Maybe we should ask NVIDIA how much they are getting when they ran benchmarks on these in their lab, they are the only place where we can get a baseline
:ack:
1

rkisnah
New hire:wave:  Apr 1st at 08:36
@aiazzag That article you shared was excellent — you clearly have a great pulse on what's happening in the market. Could you share any such docs in the AI2 - COM Ninja or in the main oci gpu channel? It’s helpful for us to see what other CSPs are doing, understand the competitive landscape, and get a broader perspective beyond our day-to-day trenches. (edited) 
aiazzag
:no_entry:  Apr 1st at 08:37
of course, which channels again ?
rkisnah
New hire:wave:  Apr 1st at 08:38
Avnish's AI2 COM Dev crew - #gb200-ai2-dev-ninjas; General OCI GPU - #oci-gpu-advanced-engineering
aiazzag
:no_entry:  Apr 1st at 08:38
Got it , will do
:thanks:
1

rkisnah
New hire:wave:  Apr 1st at 08:51
I don't know.. Might need your help or nikhil to figure out what is expected. For the results published - i don't have a good working / mathematical model/idea what the baseline should be. (edited)
Maybe we should ask NVIDIA how much they are getting when they ran benchmarks on these in their lab, they are the only place where we can get a baseline
@ngshetty or @sirampur - i can ask nvidia but they are very radio silent. It would be good if you can help me to get a working / mathematically model on what the limits should be in the network/nvlink etc. This would be akin to what  Jag and David did for the early H100(A100)- i don't want to tag them - they might not like it.
Maybe @kejoriss might be know - he is way better than most of us in Maths. :slightly_smiling_face: (edited) 
aiazzag
:no_entry:  Apr 1st at 08:57
@rkisnah how much do we get in ib_write over IB ?
rkisnah
New hire:wave:  Apr 1st at 08:58
96% Line Rate - 385 Gb/s (edited) 
Pinned by you
aiazzag
:no_entry:  Apr 1st at 08:58
busbw is calculated a bit differently so I think its normal we are not seeing line rate, more info here https://github.com/NVIDIA/nccl-tests/blob/master/doc/PERFORMANCE.md#allreduce
:ack:
1

kejoriss
  Apr 1st at 09:10
I'm not sure that Nvidia knows at this point @rkisnah.  E.g. for Indonesia we've been given performance targets that are extrapolated from H100 :shrug: .  Might be that they're getting real, measured performance numbers around the same time that we do.
:nod:
1

aiazzag
:no_entry:  Apr 1st at 09:12
Do the BusBW Numbers for NCCL all-gather using IB look good to you @kejoriss ?
kejoriss
  Apr 1st at 09:13
Yes, but don't take that as more than a handwavy statement please :slightly_smiling_face:
:ack:
1
:many-thanks:
1

kejoriss
  Apr 1st at 09:14
A2A may well have a bug in the NCCL code, that's happened from time to time :slightly_smiling_face: (edited) 
aiazzag
:no_entry:  Apr 1st at 09:15
got it, but that wont prevent workloads from doing all-to-all operations right ? or will it ?
:shrug:
1
:frogfire:
1

ngshetty
  Apr 1st at 09:31
Minor nits:
ib-write-bw should be in Gbps. Since we are connected via 400Gbps links, this should close to 400Gbps. 96% is good, but maybe we can tune things like MTU. I noticed we are still setting MTU as 2K in the Partition.
NCCL AR: If I can model a single rack like a single H100/H200 host with 72 GPUs, AllReduce should be 72*400Gbps/8 = 3600 GB/s. Obviously, we are not even close. So, there are many possibilities here: it could be that NCCL is not treating the rack as a single host for some reason (our env variables?) or their algorithms are still not fully exploiting GB200 architecture. Note, 2-node AllReduce is even higher than 3+ node numbers - so, we should expect even higher with just 2 racks.
NCCL A2A: Each GPU has 400 Gbps link in to IB => 50 GB/s theoretical max for All2All. This should be no different from H100/H200 8-GPU host.
:thanks:
1
:ack:
1

gsiekas
:no_entry:  Apr 1st at 09:31
@ngshetty The UFM is setting 2K MTU or 4K?
gsiekas
:no_entry:  Apr 1st at 09:31
H100/H200 is ~360GB/s
ngshetty
  Apr 1st at 09:31
currently, GPU-CP is calling UFM with the default MTU which is 2K. (edited) 
ngshetty
  Apr 1st at 09:32
360GB/s = ~400GB/s = 400 * 8 Gbps => Total bandwidth heading out of the box.
aiazzag
:no_entry:  Apr 1st at 09:34
NCCL AR: If I can model a single rack like a single H100/H200 host with 72 GPUs, AllReduce should be 72*400Gbps/8 = 3600 GB/s. Obviously, we are not even close. So, there are many possibilities here: it could be that NCCL is not treating the rack as a single host for some reason (our env variables?) or their algorithms are still not fully exploiting GB200 architecture. Note, 2-node AllReduce is even higher than 3+ node numbers - so, we should expect even higher with just 2 racks.
Is it because of the specifics of how busbw is calculated ? Even NVlink should push 1.8TB/s bidirectional on paper, we are getting 900GB/s in the tests here
ngshetty
  Apr 1st at 09:54
NvLink has a unidirectional b/w of 900 GB/s = 18 QM3 ASICs (across 9 switch trays) * 400 Gbps / 8 from each GPU. That is the number that will show up in bus bandwidth.
:ack:
1

ngshetty
  Apr 1st at 09:55
more reading here: https://github.com/NVIDIA/nccl-tests/blob/master/doc/PERFORMANCE.md, but of course there are a lot of papers you can read too. :slightly_smiling_face:
:many-thanks:
1

aiazzag
:no_entry:  Apr 1st at 09:58
Yes I saw that but didn't do the calculations yet , thanks for the detail
aiazzag
:no_entry:  Apr 1st at 09:59
So TLDR IB numbers are nowhere close to where we should be
gsiekas
:no_entry:  Apr 1st at 10:08
When running NCCL we need to dump the topology for every run for review.
:+1image:
1

kejoriss
  Apr 1st at 10:33
I can share this, derived from the Indonesia performance acceptance discussion.  We will test IB performance by running AR (as an example) with split mask = 72, creating 72 communicators at the same time.  In this scenario there will be no NVL comm, only IB.  We will need to hit 49GBps per.  Multiplying that out, 72*49GBps=3528GBps, or 98% of 3600GBps.  This reinforces @ngshetty statement a few messages up.
Note, this is a theoretically derived requirement.  It is not based on any actual testing on GB200 hardware. (edited) 
:thanks:
1
:+1::skin-tone-4:
1

rkisnah
New hire:wave:  Apr 1st at 11:35
Thank you oci folks (engineers and the two doctors in this discussion). This is a really good thread for me and others to understand the maths behind the numbers. I have to admit my maths is horrendous. IIT did reject me three times.  (edited) 
aiazzag
:no_entry:  Apr 1st at 11:49
@gsiekas @rkisnah do we still plan on running NCCL tests in SEA5 ?
rkisnah
New hire:wave:  Apr 1st at 11:55
That is the plan. Capacity and compute provisioning is still in the pipes. Will let you know once it is ingested properly. I don’t have a good timeline other than in a few days.
aiazzag
:no_entry:  Apr 1st at 11:56
Got it, please keep me posted