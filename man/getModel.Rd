\name{getModel}
\alias{getModel}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Compute the regression coefficients for both stages}
\description{
 \code{getModel} computes the regression coefficients for both stages. For stage 1 regression, 
 peudo-outcomes are constructed based on stage 2 coefficients. Additionally it outputs the standard outputs of the \code{lm} function; however, the inference for stage 1 parameters based on these outputs is invalid due to non-regularity. Example could be found under \code{\link{qLearn}}.
}
\usage{
getModel(s2Formula,s1Formula,completeData,
s2Treat,interact,s2Indicator,...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{s2Formula}{ stage 2 regression formula}
  \item{s1Formula}{ Stage 1 regression formula}
  \item{completeData}{ data frame containing all the variables}
  \item{s2Treat}{ character string: name of the stage 2 treatment variable}
  \item{interact}{ character vector: names of variables that interact with s2_treat}
  \item{s2Indicator}{ character string: names of the stage 2 treatment indicator variable}
  \item{\dots}{ other arguments of the \code{lm} function}
}

\value{
A list containing:

\item{s2Model}{stage2 regression model }
\item{s1Model}{stage1 regression model }
\item{pHat }{estimated non-regularity level }

}
\references{
Chakraborty, B., and Laber, E.B. (2012). Inference for Optimal Dynamic Treatment Regimes using an Adaptive m-out-of-n Bootstrap Scheme. \emph{Submitted.} 
}
\author{
Jingyi Xin \email{jx2167@columbia.edu}, Bibhas Chakraborty \email{bc2425@columbia.edu}, and Eric B.Laber \email{eblaber@ncsu.edu}
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{qLearn}}
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

## Fit model for both stages
getModel(s2Formula,s1Formula,sim,s2Treat="A2",interact=c("A1","H2"),
s2Indicator="IS2")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
