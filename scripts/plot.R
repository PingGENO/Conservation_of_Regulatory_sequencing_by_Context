# accept command line arguments and save them in a list called args
args = commandArgs(trailingOnly=TRUE)
#
library(data.table)
library(reshape)
library(dplyr)
library(ggplot2)


results = fread(input = args[1])
results = results[,c("V1", "V6")]
colnames(results) = c("ATAC.id","phyloP")
# remove everything after the last underscore of a column
results$position = gsub(".*-","", results$ATAC.id)
results$ATAC.id = gsub("-[^-]*$","", results$ATAC.id)

# diff.ATACs - differential ATAC peaks upon immune stimulations re 'Overview'
diff.ATAC = fread(input = args[2])
colnames(diff.ATAC) = c("chr","start", "end", "id")
results$diff.ATAC = ifelse(results$ATAC.id %in% diff.ATAC$id, "TRUE", "FALSE")

# calculate the averaged phyloP score in each position & plot the resul
results %>%
  group_by(position,diff.ATAC ) %>%
  dplyr::summarize(Mean = mean(phyloP, na.rm=TRUE),
                   sd = sd(phyloP),
                   n = n(),
                   se = sd / sqrt(n)) %>% 
  ggplot(., aes(x=(as.numeric(position)-100)*10, y=Mean, group = diff.ATAC, fill=diff.ATAC)) +
  geom_ribbon(aes(y = Mean, ymin = Mean - se, ymax = Mean + se, fill=diff.ATAC), alpha = 0.5) +
  geom_line() +  ylab("Average phyloP score") + xlab("Distance from ATAC center") + 
  theme_classic() + scale_fill_manual(values = c("blue","red")) + ggtitle("Monocytes open chromatin")

#sessionInfo()

# R version 4.2.1 (2022-06-23)
# Platform: x86_64-apple-darwin17.0 (64-bit)
# Running under: macOS Ventura 13.2.1
# 
# Matrix products: default
# LAPACK: /Library/Frameworks/R.framework/Versions/4.2/Resources/lib/libRlapack.dylib
# 
# locale:
#   [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
# 
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] ggplot2_3.4.2     dplyr_1.1.2       reshape_0.8.9     data.table_1.14.4
# 
# loaded via a namespace (and not attached):
#   [1] Rcpp_1.0.9        rstudioapi_0.14   magrittr_2.0.3    tidyselect_1.2.0  munsell_0.5.0     colorspace_2.0-3  R6_2.5.1          ragg_1.2.4       
# [9] rlang_1.1.1       fansi_1.0.3       plyr_1.8.7        tools_4.2.1       grid_4.2.1        gtable_0.3.1      utf8_1.2.2        cli_3.4.1        
# [17] withr_2.5.0       systemfonts_1.0.4 tibble_3.2.1      lifecycle_1.0.3   crayon_1.5.2      textshaping_0.3.6 farver_2.1.1      vctrs_0.6.3      
# [25] glue_1.6.2        labeling_0.4.2    compiler_4.2.1    pillar_1.9.0      generics_0.1.3    scales_1.2.1      pkgconfig_2.0.3  




