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
本代码为上述发表在IOTJ21'论文的仿真代码，该代码仿真了两种不同移动机制下的移动边缘服务架构。
* EdgeGO:
  本论文提出的移动机制，该机制巧妙利用了边缘计算中任务计算和服务器移动可并行性，将计算卸载过程拆分，移动服务器只需在请求上传和结果返回阶段需要覆盖终端节点。上述的移动机制可以大幅缩短任务完成总时延（atom case请见论文Section I)不止一次，访问次数不确定，路径规划更加灵活。
* MCloudlets:
  该代码仿真了现有移动边缘架构中使用服务器移动机制，即，服务器在完成当前范围内所有节点任务后，才可移动到下个节点进行服务，即每个节点只能被访问一次。

上述两种架构的路径规划代码采用的是[2-OPT算法](https://en.wikipedia.org/wiki/2-opt),该算法可在多项式时间内取得TSP问题的近似解。
  
