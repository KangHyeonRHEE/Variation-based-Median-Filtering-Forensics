function feature= Rhee_Grad_FFT(img)  

% Implementation of the Paper
% Kang Hyeon RHEE, "Median filtering detection using variation of neighboring line pairs for image forensics," Journal of Electronic Imaging, SPIE, 25(5), 2016. 
% Paper available at http://dx.doi.org/10.1117/1.JEI.25.5.053039

% $Code Author: Kang Hyeon RHEE $Date: JULY 2016 $Revision: 1.0
% Copyright: Chosun University, Korea
% This code is distributed through GitHub
% Built with Matlab R2015a

% Convert the image from uint8 to double 
[m, n] = size(img);
img = double(img); 
 
%% Find gradients 
% horizontal line 
M_d = 1:m;
M = 2:m-1;
% vertical line 
N_d = 1:n;
N = 2:n-1;
% horizontal line gradient 
gm = abs( img(M-1,N_d) - img(M,N_d) + img(M+1,N_d) - img(M,N_d)); 
% vertical line gradient  
gn  = abs( img(M_d,N-1) - img(M_d,N) + img(M_d,N+1) - img(M_d,N)); 
% hori. gradients mean 
gm_mean= mean(gm,1);
% vert. gradients mean 
gn_mean= mean(gn,2)';
 
% Most significant 9 values of the hori. and vert. gradient mean
Gftc=sort( (gm_mean(1:9) + gn_mean(1:9))/2, 'descend');
 
%% Find FFT Coefficients
% hori. line FFT coefficient
for t=1:m     
    Sh( t, :) = abs( fft( ( img( t, : )))) ; 
end
% vert. line FFT coefficient
for t=1:n    
       Sv( :, t ) = abs( fft( ( img( :, t )))) ; 
end

% horizontal line FFT coefficients gradient  
fm = abs( Sh(M-1,N_d) - Sh(M,N_d) + Sh(M+1,N_d) - Sh(M,N_d)); 
% vertical line FFT coefficients gradient  
fn =  abs( Sv(M_d,N-1) - Sv(M_d,N) + Sv(M_d,N+1) - Sv(M_d,N)); 
% hori. FFT coefficients mean 
fm_mean= mean(fm);
% vert. FFT coefficients mean
fn_mean= mean(fn,2)';
% Most significant 10 values of the hori. and vert. FFT coefficients mean
Fftc=sort( (fm_mean(1:10) + fn_mean(1:10))/2, 'descend'); 
 
%% 19-D feature set.
feature =[Fftc, Gftc]; 
end
