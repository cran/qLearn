\name{qLearn}
\alias{qLearn}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Based on the input contrast vectors, compute point estimates and construct confidence intervals using bootstrap for both stages
}
\description{
Suppose the goal is to find the point estimates and CIs for stage 1 and stage 2 contrasts \eqn{C_{1}^T \theta_1}{%
      C1^T \theta1} and \eqn{C_{2}^T \theta_2}{%
      C2^T \theta2}. Given \eqn{C_1}{%
      C1}, \eqn{C_2}{%
      C2}, regular n-out-of-n bootstrap will be used in stage 2 and different bootstrap scheme can be used in stage 1 analysis by assigning different value to \code{s1Method}. "Fixed Xi" will fix the Xi value as \code{fixedXi} and calculate the corresponding m; "Double Bootstrap" will calculate m using double bootstrap method; and the default "Regular" will skip choosing m and go with a regular bootstrap. Also m can be specified in \code{s1M} if not using "Fixed Xi" or "Double Bootstrap" 
}
\usage{qLearn(s2Formula,s1Formula,completeData,
s2Treat,interact,s2Indicator,s2Contrast,s1Contrast,
alpha=0.05,bootNum=1000,s1Method="Regular",fixedXi,
doubleBoot1Num=500,doubleBoot2Num=500,s1M,...)}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{s2Formula}{ stage 2 regression formula}
  \item{s1Formula}{ Stage 1 regression formula}
  \item{completeData}{ data frame containing all the variables}
  \item{s2Treat}{ character string: name of the stage 2 treatment variable}
  \item{interact}{ character vector: names of variables that interact with s2Treat}
  \item{s2Indicator}{ character string: names of the stage 2 treatment indicator variable}
  \item{s2Contrast}{ contrast for the stage 2 coefficients}
  \item{s1Contrast}{ contrast for the stage 1 coefficients}
  \item{alpha}{ level of significance}
  \item{bootNum}{ numbers of bootstrap sampling in constructing CIs}
  \item{s1Method}{ character string: method to choose stage 1 bootstrap sample size, m;
                    "Double Bootstrap" will calculate m using double bootstrap method;
                    "Fixed Xi" will fix the Xi value and calculate the corresponding m;
                    "Regular" will use a regular n-out-of-n bootstrap for stage 1.}
  \item{fixedXi}{ fixed xi value if \code{s1Method}="Fixed Xi"}
  \item{doubleBoot1Num}{ numbers of bootstrap sampling for first order bootstrap if \code{s1Method}="Double Bootstrap"}
  \item{doubleBoot2Num}{ numbers of bootstrap sampling for second order bootstrap if \code{s1Method}="Double Bootstrap"}
  \item{s1M}{ specify m if necessary}
  \item{\dots}{ other arguments of the \code{lm} function}
}

\value{
A list containing:

\item{s1Coefficients  }{stage 1 regression coefficients }
\item{s2Coefficients  }{stage 2 regression coefficients }
\item{s1Inference }{stage 1 coefficients confidence interval based on stage1 contrast }
\item{s2Inference }{stage 2 coefficients confidence interval based on stage2 contrast }
\item{s1Size }{stage 1 bootstrap sample size }
}
\references{
Chakraborty, B., and Laber, E.B. (2012). Inference for Optimal Dynamic Treatment Regimes using an Adaptive m-out-of-n Bootstrap Scheme. \emph{Submitted.} 
}
\author{
Jingyi Xin \email{jx2167@columbia.edu}, Bibhas Chakraborty \email{bc2425@columbia.edu}, and Eric B.Laber \email{eblaber@ncsu.edu}
}


%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{getModel}}  \code{\link{chooseMDoubleBootstrap}}
}
\examples{
set.seed(100)
# Simple Simulation on 1000 subjects
sim<-matrix(0,nrow=1000,ncol=7)
colnames(sim)<-c("H1","A1","Y1","H2","A2","Y2","IS2")
sim<-as.data.frame(sim)

# Randomly generate stage 1 covariates and stage 1 and 2 treatments
sim[,c("H1","A1","A2")]<-2*rbinom(1000*3,1,0.5)-1

# Generate stage 2 covariates based on H1 and T1
expit<-exp(0.5*sim$H1+0.5*sim$A1)/(1+exp(0.5*sim$H1+0.5*sim$A1))
sim$H2<-2*rbinom(1000,1,expit)-1

# Assume stage 1 outcome Y1 is 0
# Generate stage 2 outcome Y2 
sim$Y2<-0.5*sim$A2+0.5*sim$A2*sim$A1-0.5*sim$A1+rnorm(1000)

# Randomly assign 500 subjects to S2
sim[sample(1000,500),"IS2"]<-1 
sim[sim$IS2==0,c("A2","Y2")]<-NA

# Define models for both stages
s2Formula<-Y2~H1*A1+A1*A2+A2:H2
s1Formula<-Y1~H1*A1

## Fixed Xi as 0.05
qLearn(s2Formula,s1Formula,sim,s2Treat="A2",interact=c("A1","H2"),
s2Indicator="IS2",s1Method="Fixed Xi",fixedXi=0.05,bootNum=100)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
