clc;
clear all;
close all;


fs=8000;
time =0.5;
n= 0:1/fs:time-1/fs; 
samples= length(n)
LMS_taps= 64;
w=zeros(1,256);
%e=zeros(1,256);
y=zeros(1,samples);
delay_line = zeros(1,256);
f1= 200;
f2= 700;
d= 0.6* sin(2* pi * f1 * n)+ 0.3 *sin(2* pi * f2 * n);
v= rand(size(n));
v= sqrt(v).*rand(size(n));
%x = 0.5*d+ 0.3*sin(2* pi * f2 * n);
x = d+ 0.5*v;

figure(1);
subplot(2,1,1);
plot(1000*n(1:256),x(1:256));
title('Input signal')
xlabel("time in ms")
ylabel("amplitude")
subplot(2,1,2);
plot(1000*n(1:256),d(1:256));
title('Desired signal');
xlabel("time in seconds")
ylabel("amplitude")

alpha=0.01;


%main process loop

for i=1:samples
  
  %update filter delay line every sample
  delay_line(LMS_taps)=x(i);
  %filtering 
  y(i)=dot(delay_line,w);
  
  %calculate error
  e= d(i)-y(i);
  
  %update the taps
  
  w=w+alpha.*e.*delay_line;
  
  %shift delay line 
  delay_line(1:LMS_taps-1)=delay_line(2:LMS_taps);
  
endfor

%verification
N=512;
FFT_len = N;
FFT_samples =(-1*fs/2): fs/(FFT_len):((fs/2)-1);
X= fft(x,FFT_len);
X1=fftshift(X);
X1_mag = (1/FFT_len)*abs(X1);
figure(2);
subplot(3,1,1)
plot(FFT_samples,X1_mag);

X= fft(d,FFT_len);
X1=fftshift(X);
X1_mag = (1/FFT_len)*abs(X1);
subplot(3,1,2)
plot(FFT_samples,X1_mag);

X= fft(y,FFT_len);
X1=fftshift(X);
X1_mag = (1/FFT_len)*abs(X1);
subplot(3,1,3)
plot(FFT_samples,X1_mag);

