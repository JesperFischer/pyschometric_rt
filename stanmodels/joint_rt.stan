functions{
  
  vector psychometric(vector x, real threshold, real slope, real lapse){
    
    vector[size(x)] p = lapse + (1-2*lapse) * (0.5+0.5 * erf((x - threshold)/(slope*sqrt(2))));
  
    return(p);
      
  }
  
  vector psychometric_nolapse(vector x, real threshold, real slope){
    
    vector[size(x)] p = 0.5+0.5 * erf((x - threshold)/(slope*sqrt(2)));
  
    return(p);
      
  }
  
  vector bern_variance_trans(vector p, real intercept, real slope){
    
    vector[size(p)] mu = intercept + slope .* p .* (1-p);
  
    return(mu);
      
  }
  
  
}


data {
  int<lower=0> N;
  
  vector[N] stim;

  array[N] int resp;
  vector[N] RT;
  
    
}

transformed data{
  
  real minRT = min(RT);
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real threshold_uncon;
  real slope_uncon;
  real lapse_uncon;
  real rt_int_uncon;
  real rt_beta_uncon;
  real rt_sd_uncon;
  real rt_shift_uncon;
  
  
}

transformed parameters{
  real threshold = threshold_uncon;
  real slope = exp(slope_uncon);
  real lapse = inv_logit(lapse_uncon)/2;
  real rt_int = rt_int_uncon;
  real rt_beta = rt_beta_uncon;
  real rt_sd = exp(rt_sd_uncon);
  real rt_shift = inv_logit(rt_shift_uncon);
  
  
  vector[size(stim)] p = psychometric(stim,threshold,slope,lapse);
  
  
  vector[size(stim)] p_nolapse = psychometric_nolapse(stim,threshold,slope);
  
  
  vector[size(stim)] mu_rt = bern_variance_trans(p_nolapse,rt_int,rt_beta);

}

model {
  //priors
  threshold_uncon ~ normal(0,50);
  slope_uncon ~ normal(0,3);
  lapse_uncon ~ normal(-4,2);
  //rt model
  rt_int_uncon ~ normal(0,3);
  rt_beta_uncon ~ normal(0,3);
  rt_sd_uncon ~ normal(0,3);
  rt_shift_uncon ~ normal(0,1);
  
  //model
  target += bernoulli_lpmf(resp | p);
  target += lognormal_lpdf(RT - rt_shift * minRT | mu_rt, rt_sd);

}

