# YODA-project-visualization
This R code processes metadata from Johnston & Johnson clinical trials provided by the Yale Open Data Access Project and visualize it in an igraph network in an attempt to get a sense for how clinical trial data is reused and what it is used for. These clinical trials are listed here: https://yoda.yale.edu/table-3-data-requests-approved 

### data-transform.R
- Handles the data processing to create the nessisary nodes and edges files required by the igraph package

### yoda-data-reuse.R
- Creates a network diagram showing general data reuse through the YODA Project

### published-protocols.R
- Creates a network diagram showcasing the types of publications that result from data reuse through the YODA Project 

##### note: raw data is not included alongside these code files. 
