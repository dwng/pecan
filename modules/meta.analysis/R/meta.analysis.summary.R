#-------------------------------------------------------------------------------
# Copyright (c) 2012 University of Illinois, NCSA.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the 
# University of Illinois/NCSA Open Source License
# which accompanies this distribution, and is available at
# http://opensource.ncsa.illinois.edu/license.html
#-------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------#
##'
##' @name pecan.ma.summary
##' @title Generate summary statitics and diagnostics for PEcAn meta.analysis
##' @param mcmc.object JAGS mcmc output from \code{\link{pecan.ma}}
##' @param pft plant functional type
##' @param outdir output directory
##' @param threshold Gelman-Rubin convergence threshold; default = 1.1 
##' @export
##'
##' @examples
##' \dontrun{
##' summary <- pecan.ma.summary(trait.mcmc,settings$pfts$pft,settings$outdir,settings$meta.analysis$threshold)
##' }
##' @author David LeBauer, Shawn Serbin
pecan.ma.summary <- function(mcmc.object, pft,outdir, threshold=1.1){
  if(!is.null(settings$meta.analysis$threshold)) {
    threshold = settings$meta.analysis$threshold
  }
  fail = FALSE
  sink(file = paste(outdir,'meta-analysis.log',sep=""), append = TRUE, split = TRUE)
  for (trait in names(mcmc.object)){
    ## reordering maparms so that beta.o etc not sent to end
    .maparms <- names(mcmc.object[[trait]][1,][1][[1]])
    .parms <- c('beta.o', 'thetaSD', 'trtSD', 'ySD')
    maparms <- .maparms[ c(which(.maparms %in% .parms), which(!.maparms %in% .parms))]

    ## plots for mcmc diagnosis
    pdf(paste(outdir, 'ma.summaryplots.', pft, '.', trait, '.pdf', sep = ''))
    for (i in maparms) {
      plot(mcmc.object[[trait]][,i], trace = FALSE, density = TRUE,
           main = paste('summary plots of',i ,'for', pft, trait))
      box(lwd=2)
      plot(mcmc.object[[trait]][,i],density = FALSE)
      box(lwd=2)
      autocorr.plot(mcmc.object[[trait]][,i][1], xlim = c(1, 50))
      box(lwd=2)
    }
    dev.off()
 
    ## G-R diagnostics to ensure convergence    
    gd<-gelman.diag(mcmc.object[[trait]])
    mpsrf<-round(gd$mpsrf,digits=4)
    if(mpsrf < threshold){
      writeLines(paste ("JAGS model converged for", pft, trait,
                    "\nGD MPSRF = ",mpsrf,"\n", sep=" "))
    } else {
      writeLines( paste ("JAGS model did not converge for", pft, trait,
                   "\nGD MPSRF = ",mpsrf,"\n", sep=" ") )
      fail = TRUE
    }
    
  }
  if(fail)warning('JAGS model failed to converge for one or more pft.')
  sink()
}
#==================================================================================================#


####################################################################################################
### EOF.  End of R script file.    					
####################################################################################################
