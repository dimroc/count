# Overview

1. Rails application that interacts with a crowd counting python machine learning service via gRPC.
2. iOS app and macOS Playground that uses a CoreML pipeline to count the number of people in an image.

Click on the individual folders for README's specific to each section.

For an overview of the machine learning and Rails application, please visit [this blog post](http://blog.dimroc.com/2017/11/19/counting-crowds-and-lines/).

# Checkout with git-lfs

We use [`git-lfs`](https://git-lfs.github.com/) to store images in git.
For a faster check out, please first do:

```bash
git lfs fetch
git pull
```

# /secrets folder and Google Cloud

```bash
$ cat .envrc
export CLOUDSDK_PYTHON=/Users/dimroc/.pyenv/versions/miniconda2-4.1.11/bin/python2
export GOOGLE_APPLICATION_CREDENTIALS=../secrets/gcloudstorage.development.json
gcloud config set project counting-company-production
```

# Datasets

- [UCF Crowd Counting Data Set](http://crcv.ucf.edu/data/crowd_counting.php)
- [CUHK Mall Dataset](http://personal.ie.cuhk.edu.hk/~ccloy/downloads_mall_dataset.html)
- [Shakecam](https://www.shakeshack.com/location/madison-square-park/)

# References

- Multi-scale Convolutional Neural Networks for Crowd Counting  
  Lingke Zeng, Xiangmin Xu, Bolun Cai, Suo Qiu, Tong Zhang  
  [Page](https://arxiv.org/abs/1702.02359) [PDF](https://arxiv.org/pdf/1702.02359.pdf)
- Fully Convolutional Crowd Counting On Highly Congested Scenes  
  Mark Marsden, Kevin McGuinness, Suzanne Little and Noel E. O’Connor  
  [PDF](https://arxiv.org/pdf/1612.00220.pdf)
- Multi-Source Multi-Scale Counting in Extremely Dense Crowd Images  
  Haroon Idrees, Imran Saleemi, Cody Seibert, Mubarak Shah  
  IEEE International Conference on Computer Vision and Pattern Recognition (CVPR), 2013  
  [PDF](http://crcv.ucf.edu/papers/cvpr2013/Counting_V3o.pdf)
- From Semi-Supervised to Transfer Counting of Crowds  
  C. C. Loy, S. Gong, and T. Xiang  
  in Proceedings of IEEE International Conference on Computer Vision, pp. 2256-2263, 2013 (ICCV)  
  [PDF](http://personal.ie.cuhk.edu.hk/~ccloy/files/iccv_2013_crowd.pdf) [Project Page](http://personal.ie.cuhk.edu.hk/~ccloy/project_semi_counting/index.html)
- Cumulative Attribute Space for Age and Crowd Density Estimation  
  K. Chen, S. Gong, T. Xiang, and C. C. Loy  
  in Proceedings of IEEE Conference on Computer Vision and Pattern Recognition, pp. 2467-2474, 2013 (CVPR, Oral)  
  [PDF](http://personal.ie.cuhk.edu.hk/~ccloy/files/cvpr_2013.pdf) [Project Page](http://personal.ie.cuhk.edu.hk/~ccloy/project_cumulative_attribute/index.html)
- Crowd Counting and Profiling: Methodology and Evaluation  
  C. C. Loy, K. Chen, S. Gong, T. Xiang  
  in S. Ali, K. Nishino, D. Manocha, and M. Shah (Eds.), Modeling, Simulation and Visual Analysis of Crowds, Springer, vol. 11, pp. 347-382, 2013  
  [DOI](http://link.springer.com/chapter/10.1007/978-1-4614-8483-7_14) [PDF](http://personal.ie.cuhk.edu.hk/~ccloy/files/crowd_2013.pdf)
- Feature Mining for Localised Crowd Counting  
  K. Chen, C. C. Loy, S. Gong, and T. Xiang  
  British Machine Vision Conference, 2012 (BMVC)  
  [PDF](http://personal.ie.cuhk.edu.hk/~ccloy/files/bmvc_2012b.pdf) [Project Page](http://personal.ie.cuhk.edu.hk/~ccloy/project_feat_mine_count/index.html)
