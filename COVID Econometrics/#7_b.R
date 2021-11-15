#New function allowing to customise the plot
gaps.plot_modify <- function (synth.res = NA, dataprep.res = NA, Main= "", Ylab = c("Title"), 
          Xlab = c("Time"), 
          tr.intake = NA, Ylim = NA, Z.plot = FALSE) 
{
  if (Z.plot == FALSE) {
    if (sum(is.na(dataprep.res$Y1plot)) > 0) {
      stop("\n\n#####################################################", 
           "\nYou have missing Y data for the treated!\n\n")
    }
    if (sum(is.na(dataprep.res$Y0plot)) > 0) {
      stop("\n\n#####################################################", 
           "\nYou have missing Y data for the controls!\n\n")
    }
    gap <- dataprep.res$Y1plot - (dataprep.res$Y0plot %*% 
                                    synth.res$solution.w)
    if (sum(is.na(Ylim)) > 0) {
      Ylim <- c(-(0.3 * max(abs(gap)) + max(abs(gap))), 
                (0.3 * max(abs(gap)) + max(abs(gap))))
    }
    plot(dataprep.res$tag$time.plot, gap, t = "l", col = "black", 
         lwd = 2, main = Main, xlab = Xlab, ylim = Ylim, ylab=Ylab,
         xaxs = "i", yaxs = "i",axes=F)
    axis(side=2, at=round(c(-0.019,-0.01,0,0.01),digits = 2),)
    axis.Date(side=1, at=as.Date(c("2020-12-07","2020-12-14","2020-12-21")))
  }
  else {
    gap <- dataprep.res$Z1 - (dataprep.res$Z0 %*% synth.res$solution.w)
    if (sum(is.na(Ylim)) > 0) {
      Ylim <- c(-(0.3 * max(abs(gap)) + max(abs(gap))), 
                (0.3 * max(abs(gap)) + max(abs(gap))))
    }
    plot(dataprep.res$tag$time.optimize.ssr, gap, t = "l", 
         col = "black", lwd = 2, main = Main, ylab = Ylab, 
         xlab = Xlab, ylim = Ylim, xaxs = "i", yaxs = "i")
  }
  par(xpd=FALSE)
  abline(h = 0, col = "black", lty = "dashed", lwd = 2)
  abline(v = as.Date("2020-12-14"), col = "black", lty = "dotted", lwd = 2)
}
