function C_d = cd_lookup(cd_rp_term)

% coefficient data from data_curve_fit.m
a = [6.004233398286580;
    0.070613418692467;
    -1.228107136922256;
    0.689127321511144;
    -0.212388678514154;
    0.039961599428351;
    -0.004741357447951;
    0.000355824935368;
    -0.000016374544806;
    0.000000421616211;
    -0.000000004651509];



% take the log of the C_d R_p value
x = log(cd_rp_term);

% compute log_C_d using the polynomial coefficients from the curve fit
log_C_d = a(1) + a(2)*x + a(3)*x^2 + a(4)*x^3 + a(5)*x^4 + a(6)*x^5 + ...
          a(7)*x^6 + a(8)*x^7 + a(9)*x^8 + a(10)*x^9 + a(11)*x^10;

% exponentiate to get back out of log space
C_d = exp(log_C_d);


end