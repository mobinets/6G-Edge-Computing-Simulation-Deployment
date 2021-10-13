# Simulation for 6G Edge Computing -- A Mobile Resource-sharing Framework for 5G/6G Edge Computing in Massive IoT Systems

# Introduction
This repo contians the simulation code used in the publication:
> Cong R, Zhao Z, Min G, et al. EdgeGO: A Mobile Resource-sharing Framework for 5G/6G Edge Computing in Massive IoT Systems[J]. IEEE Internet of Things Journal, 2021.

Please copy the following bib info for citations.

> @article{cong2021edgego,
  title={EdgeGO: A Mobile Resource-sharing Framework for 6G Edge Computing in Massive IoT Systems},
  author={Cong, Rong and Zhao, Zhiwei and Min, Geyong and Feng, Chenyuan and Jiang, Yuhong},
  journal={IEEE Internet of Things Journal},
  year={2021},
  publisher={IEEE}
}

## Description
It is the simulation code used in the work of EdgeGo which has been accepted by IoTJ '21. In this code, we simulate and compare the two mobile frameworks in edge computing.
* EdgeGO:
  This the mobile framework proposed in this work, in which we leverage the parallelism between server movement and task computation and decouple the process of task offloading into request collection, task computation as well as returning result. In this way, servers only need to move to the communication range of IoT nodes for request collection and returning results, instead of staying at place waiting the completion of task processing. Utilizing this pioneering framework, the overall delay of IoT nodes placed in the network will be drastically reduced. However, it also make path planning be more flexible and intractable, due to the uncertainty of visit times.
* MCloudlets:
  MCloudlets is the movement scheme of servers in existing mobile edge frameworks. In MCloudlets, network operators also utilize mobile edge servers to serve IoT nodes. However, mobile edge servers (in our simulation we call them "mobile cloudlets") have to move to the next destination until finishing the tasks from IoT devices in current communication range.

Both of these two mobile frameworks optimize the server paths by [the 2-OPT algorithm](https://en.wikipedia.org/wiki/2-opt), which can get the approximate optimal solution of the TSP in polynomial time.

  
