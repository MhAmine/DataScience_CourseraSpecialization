
# Values for one-sample test
#H_0: mu_0 = 0
mu_0 = 0

#H_a: mu_a > mu_0
mu_a = .01

std = .04
n = 100

# Values for two-sample tests
mu_x = 1
std_x = 1.5

mu_y = -3
std_y = 1.8

#n = 18
n_x = 9
n_y = 9

quantile = .975


# Values for paired t test
base = c(140,138,150,148,135)
week2 = c(132,135,151,146,130)

t.test(base,week2, paired = TRUE,alternative = "t")

# Independent group t-intervals
Sp2 = ((n_x-1)*std_x^2 + (n_y-1)*std_y^2)/(n-2)

conf_int = mu_x-mu_y + c(-1,1)*qt(quantile, n-2)*sqrt(Sp2/n)
t_statistic = (mu_x - mu_y)/sqrt(Sp2*(1/n_x+1/n_y))
pt(t_statistic, 16)



### INSERT RIGHT QUANTILE
p_value = pt(t_quantile, n-2, lower.tail = FALSE)


# unequal variances t-test
df_numerator = (std_x^2/n_x+std_y^2/n_y)^2
df_denominator = (std_x^2/n_x)^2/(n_x-1) + (std_y^2/n_y)^2/(n_y-1)
df = df_numerator/df_denominator

conf_int_uneq_var = mu_x-mu_y + c(-1,1)*qt(quantile, df)*(std_x^2/n_x + std_y^2/n_y)^0.5

# Testing Power
alpha = 0.05
z = qnorm(1 - alpha)
pnorm(mu_0 + z * std/sqrt(n), mean = mu_a, sd = std/sqrt(n), lower.tail = FALSE)

power.t.test(power = 0.9, delta = .01, sd = .04, type = "one.sample", alt = "one.sided")$n



### From the lectures
# Plot comparing t-distr. with normal distr.
k <- 1000
xvals <- seq(-5, 5, length = k)
myplot <- function(df){
  d <- data.frame(y = c(dnorm(xvals), dt(xvals, df)),
                  x = xvals,
                  dist = factor(rep(c("Normal", "T"), c(k,k))))
  g <- ggplot(d, aes(x = x, y = y))
  g <- g + geom_line(size = 2, aes(colour = dist))
  g
}
manipulate(myplot(mu), mu = slider(1, 20, step = 1))


#
pvals <- seq(.5, .99, by = .01)
myplot2 <- function(df){
  d <- data.frame(n= qnorm(pvals),t=qt(pvals, df),
                  p = pvals)
  g <- ggplot(d, aes(x= n, y = t))
  g <- g + geom_abline(size = 2, col = "lightblue")
  g <- g + geom_line(size = 2, col = "black")
  g <- g + geom_vline(xintercept = qnorm(0.975))
  g <- g + geom_hline(yintercept = qt(0.975, df))
  g
}
manipulate(myplot2(df), df = slider(1, 20, step = 1))
