# Benchmark-CTCM-ST
Datasets for our new paper: [Benchmarking cell-type clustering methods for spatially resolved transcriptomics data](https://doi.org/10.1093/bib/bbac475).

## 0. Sample folder structure
```
Benchmark-CTCM-ST
│   README.md
└───Dataset1/
│   └───images_sd0.5/
│       │  rgb_img1.png #Simulated images for replicate 1 with standard deviation 0.5
│       │  rgb_img2.png
│       │   ...
│   └───images_sd5/
│       │  rgb_img1.png
│       │   ...
│   └───images_sd10/
│       │  rgb_img1.png
│       │   ...
│   └───images_sd25/
│       │  rgb_img1.png
│       │   ...
│   └───images_sd50/
│       │  rgb_img1.png
│       │   ...
│   └───simcounts/
│       │   Dataset1_counts1.rds #Simulated counts for replicate 1
│       │   Dataset1_counts2.rds
│       │   ...
│   └───spatial_info/
│       │   spatial_trans1.tsv #Pixel-mapped spatial coordinates
│       │   spatial_trans2.tsv
│       │   ...
│   └───true_cl/
│       │   Dataset1_true_cl1.rds #Cell types assigned through RShiny
│       │   Dataset1_true_cl2.rds
│       │   ...
```

## 1.  Simulated counts
A .rds file containing:
* Genes X Cell matrix (dgCMatrix)
## 2. Spatial location information
A .tsv file containing 3 columns:
* cell index
* X0: x-coordinate pixel-mapped values
* X1: y-coordinate pixel-mapped values

## 3. Simulated histology images
A .png image with shape (288, 288, 3) generated with a standard deviations of 0.5, 5, 10, 25, and 50.
## 4. true_cl: Ground truth cell types assigned through RShiny
* Factor with k levels, where k is the number of unique cell types assigned.
