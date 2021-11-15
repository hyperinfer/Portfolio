#New function allowing to customise the plot
path.plot_modify<-function (synth.res = NA, dataprep.res = NA, tr.intake = NA, 
          Ylab = c("Y Axis"), Xlab = c("Time"), Ylim = NA, Legend = c("Treated", 
                                                                      "Synthetic"), Legend.position = c("topright"), Main = NA, 
          Z.plot = FALSE) 
{par(xpd=FALSE)
  par(las=1)
  if (Z.plot == FALSE) {
    if (sum(is.na(dataprep.res$Y1plot)) > 0) {
      stop("\n\n#####################################################", 
           "\nYou have missing Y data for the treated!\n\n")
    }
    if (sum(is.na(dataprep.res$Y0plot)) > 0) {
      stop("\n\n#####################################################", 
           "\nYou have missing Y data for the controls!\n\n")
    }
    y0plot1 <- dataprep.res$Y0plot %*% synth.res$solution.w
    if (sum(is.na(Ylim)) > 0) {
      Y.max <- max(c(y0plot1, dataprep.res$Y1plot))
      Y.min <- min(c(y0plot1, dataprep.res$Y1plot))
      Ylim <- c((Y.min - 0.3 * Y.min), (0.3 * Y.max + Y.max))
    }
    plot(dataprep.res$tag$time.plot, dataprep.res$Y1plot, 
         t = "l", col = "black", lwd = 2, main = Main, ylab = "Growth rate of cumulative cases (daily)", 
         xlab = Xlab, xaxs = "i", yaxs = "i", ylim = Ylim, axes=FALSE)
    axis(side=2, at=round(c(0,0.05,0.1,0.15,0.2,0.25, 0.3),digits = 2),)
    axis.Date(side=1, at=as.Date(c("2020-04-01","2020-05-01","2020-06-01","2020-07-01","2020-08-01","2020-09-01","2020-10-01","2020-11-01","2020-12-01", "2020-12-31")))
    lines(dataprep.res$tag$time.plot, y0plot1, col = "red", lwd = 2, cex = 4/5)
  }
  else {
    z0plot <- dataprep.res$Z0 %*% synth.res$solution.w
    if (sum(is.na(Ylim)) > 0) {
      Y.max <- max(c(z0plot, dataprep.res$Z1))
      Y.min <- min(c(z0plot, dataprep.res$Z1))
      Ylim <- c((Y.min - 0.3 * Y.min), (0.3 * Y.max + Y.max))
    }
    plot(dataprep.res$tag$time.optimize.ssr, z0plot, t = "l", 
         col = "black", lwd = 2, main = Main, ylab = Ylab, 
         xlab = Xlab, xaxs = "i", yaxs = "i", ylim = Ylim)
    lines(dataprep.res$tag$time.optimize.ssr, dataprep.res$Z1, 
          col = "black", lty = "dashed", lwd = 2, cex = 4/5)
  }
  abline(v = as.Date("2020-12-14"), lty = 3, col = "black", lwd = 2)
  par(xpd=TRUE)
  if (sum(is.na(Legend)) == 0) {
    legend(Legend.position, inset=c(0,-0.5), legend = Legend, bty = "n", lty = 1, col = c("black", 
                                                                "red"), lwd = c(2, 2), cex = 6/7)
  }
}
