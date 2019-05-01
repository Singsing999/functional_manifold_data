setwd('./Users/UQAM/Dropbox/Marie-Moi/Susan_project/manifold learning/Geo_dist_calculation/Cluster_results/spartanSim_clusterOutput')

choose_el<- function(list_in,ind1,ind2){
  list_in[[ind1]][ind2]
}

choose_el2<-function(ind_vec,list_in1){
  lapply(list_in1,choose_el,ind1=ind_vec[1],ind2=ind_vec[2])
}

create_boxplot<- function(sce_details,mat_ind){
  data_sce = list.files(pattern=paste("_sce=1_samplesize=",sce_details[1],"_SNR=",sce_details[2],"_reg_sampling=",sce_details[3],"_s=",sce_details[4],"_mc=*",sep=""))
  raw_results<-lapply(data_sce,readRDS)
  
  temp_res<-apply(mat_ind,1,choose_el2,list_in1=raw_results)
  temp_res2<- lapply(temp_res,unlist,use.names=FALSE)
  results<- matrix(unlist(temp_res2,use.names=FALSE),ncol=18)
  
  ### We plot one boxplot per method and per assesment measure
  pdf(paste("samplesize=",sce_details[1],"_SNR=",sce_details[2],"_reg_sampling=",sce_details[3],"_s=",sce_details[4],".pdf",sep=""),width=15,height=5)
  par(mfrow=c(1,3))
  boxplot(results[,1:6],main="relative MSE",names=c("true","noisy","smoo","p-iso","mds","RP"))
  boxplot(results[,7:12],main="AUC of entrywise epsilon-isometry",names=c("true","noisy","smoo","p-iso","mds","RP"))
  boxplot(results[,13:18],main="Pearson correlation",names=c("true","noisy","smoo","p-iso","mds","RP"))
  dev.off()
  
}

combination_res_assess<- cbind(rep(1:6,3),rep(1:3,each=6)) # 18 combinations of methods and assesment measures
combination_para <- expand.grid(c(100,250),c(0.5,0.1),c(0,1),2:4) # 24 combinations of the parameters

apply(combination_para,1,create_boxplot,mat_ind=combination_res_assess)


