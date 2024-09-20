
#Helper functions:

#psychometric probit function for threshold slope and lapse
probit_psychometric = function(x,threshold,slope,lapse){
  return(lapse+(1-2*lapse)*(0.5+0.5*pracma::erf((x-threshold)/(slope*sqrt(2)))))
}
#psychometric probit function for threshold slope
probit_psychometric_nolapse = function(x,threshold,slope,lapse){
  return((0.5+0.5*pracma::erf((x-threshold)/(slope*sqrt(2)))))
}


generate_trial = function(x,threshold,slope,lapse,rt_int,rt_beta,rt_sd,rt_shift,minRT,participant){
  
  expectation =  probit_psychometric_nolapse(x,threshold, slope)
  
  mu_rts = rt_int + rt_beta * expectation * (1-expectation)
  
  rts = rlnorm(length(mu_rts), mu_rts, rt_sd) + rt_shift * minRT
  
  p_resp = probit_psychometric(x,threshold, slope, lapse)
  
  resp = rbinom(length(expectation),1,p_resp) 
  
  return(data.frame(rts,resp,x,participant))
}



# library(tidyverse)
# parameters = data.frame(threshold = 0, slope = 3, lapse = 0.05, rt_int = 0, rt_beta = 3, rt_sd = 0.3, rt_shift = 0.5, minRT = 0.2, participant = 1, stimulus = "random")
#outputs the responses as a dataframe
simulate_psychometric = function(parameters, seed = NULL){
  
  if(exists("seed")){
    seed = set.seed(seed)
  }

  ## how to generate stimulus values:
  if("stimulus" %in% colnames(parameters)){
    if(parameters$stimulus[1] == "random")
      x = seq(-20,20,by = 0.5)
    print("Using randomly simulated stimulus values")
    # Not ready yet
  }else if(parameters$stimulus[1] == "pathfinder"){
    x = get_pathfinder_stim()
    print("Using pathfinder simulated stimulus values")
  }else{
    x = seq(-20,20,by = 0.5)
    print("Using randomly simulated stimulus values")
  }
  
  
  trial_df = parameters %>% rowwise() %>% summarize((generate_trial(x, threshold,slope,lapse,rt_int,rt_beta,rt_sd,rt_shift,minRT,participant)))
  
  return(trial_df)
}


plot_joint_rts_single = function(df){
  
  plot = df %>% mutate(trials = 1:n()) %>% pivot_longer(cols = c("resp","rts")) %>% 
    ggplot(aes(x = x, y =value))+geom_point()+
    facet_wrap(~name, scales = "free", ncol = 1)+
    geom_smooth()+theme_minimal()
  
  return(plot)
  
}


# fitted

generate_expect = function(x,threshold,slope,lapse,rt_int,rt_beta,rt_sd,rt_shift,minRT,participant){
  
  expectation =  probit_psychometric_nolapse(x,threshold, slope)
  
  mu_rts = rt_int + rt_beta * expectation * (1-expectation)
  
  rts = rlnorm(length(mu_rts), mu_rts, rt_sd) + rt_shift * minRT
  
  p_resp = probit_psychometric(x,threshold, slope, lapse)
  
  resp = rbinom(length(expectation),1,p_resp) 
  
  return(data.frame(rts = rts, mu_rts = mu_rts,resp = resp,expectation = p_resp,x = x,participant))
}



plot_joint_rts_single_v2 = function(df){
  
  plot1 = df %>% mutate(trials = 1:n())  %>% 
    ggplot(aes(x = x, y =resp))+geom_point()+
    geom_smooth()+theme_minimal()
  
  plot2 = df %>% mutate(trials = 1:n())%>% 
    ggplot(aes(x = x, y =rts))+geom_point()+
    geom_smooth()+theme_minimal()+
    scale_y_continuous(limits = c(0,5), breaks = seq(0,5,1))
  
    
  return(plot1/plot2)
  
}
