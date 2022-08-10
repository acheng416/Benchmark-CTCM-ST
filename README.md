# Benchmark-CTCM-ST
Datasets for "Benchmarking cell-type clustering methods for spatially resolved transcriptomics data"


# Benchmark-CTCM-ST
Datasets for "Benchmarking cell-type clustering methods for spatially resolved transcriptomics data"

## 0. Sample folder structure
```
Benchmark-CTCM-ST
│   README.md
└───Dataset1
│   └───images
│       │  rgb_img1.png #Simulated images for replicate 1
│       │  rgb_img2.png
│       │   ...
│   └───images_sd0.5
│       │  rgb_img1.png #Simulated images for replicate 1 with standard deviation 0.5
│       │  rgb_img2.png
│       │   ...
│   └───simcounts
│       │   Dataset1_counts1.rds #Simulated counts for replicate 1
│       │   Dataset1_counts2.rds
│       │   ...
│   └───spatial_info
│       │   spatial_trans1.tsv #Pixel-mapped spatial coordinates
│       │   spatial_trans2.tsv
│       │   ...
```

## 1.  Simulated counts
* Genes X Cell (dgCMatrix)
## 2. Spatial location information
A .tsv file containing 3 columns:
* index
* X0: x-coordinate pixel-mapped values
* X1: y-coordinate pixel-mapped values


## 3. Simulated histology images
A .png image with shape (288, 288, 3) generated with a default standard deviation of 0.5. Variations are also provided, with standard deviations of 0.5, 5, 10, 25, and 50 inline with the SD variation analyses in the paper.
