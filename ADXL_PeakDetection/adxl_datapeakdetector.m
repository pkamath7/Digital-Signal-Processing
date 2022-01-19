clc;
clear all;
close all;
pkg load signal;

%define arrays
peak_k=3;
peak_z1=zeros(peak_k,1);

%load input data
ip= load('ADXL_mean_dat2.txt');
ip_len=length(ip);
n=0:ip_len-1;
fs=1000/20;
op =zeros(ip_len,1);
%plot input
figure(1);
plot(n,ip);
threshold=0.25;

temp=0;
k=0;
j=0;
for m=1:ip_len
 %peak finding
 for l=1:peak_k-1
  peak_z1(l)= peak_z1(l+1);
 end
  peak_z1(peak_k)=ip(m); 
 
  if((peak_z1(2) > peak_z1(1)) && (peak_z1(2)> peak_z1(3)) && (peak_z1(2) > threshold))
     op(m)=1;
  else
     op(m)=0;
  endif
end

n=0:length(op)-1;
%plot output
figure(2);
plot(n',op , n', ip);