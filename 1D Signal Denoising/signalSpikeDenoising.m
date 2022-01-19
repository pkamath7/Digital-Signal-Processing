clear all;
close all;
clc;


%read the signal 
load("denoising_codeChallenge.mat");
n=length(origSignal);
figure(1);
subplot(3,2,1);
plot(1:n, origSignal);
signal=origSignal;
%histogran
subplot(3,2,2);
hist(origSignal,100);

%choose the thresholds based on histogram distribution, done by visual inspection here
thresholdA=-4;
thresholdB=4;

%get the outliers
outliersB= find( (origSignal >thresholdB));
outliersA= find( (origSignal <thresholdA));
outliers = [outliersA outliersB];
outliers=sort(outliers);
subplot(3,2,3);
num_outliers= length(outliers);
plot(1:num_outliers,outliers);

%median filter around the outliers
k=20; %2k+1 points (-k i k)

for i= 1:num_outliers
  %extract subarray
  lowerBound=max(1,outliers(i)-k);
  upperBound=min(outliers(i)+k,n);
  
  signal(outliers(i))=median(origSignal(lowerBound:upperBound));
end

figure(2);
plot(1:n, signal);


%mean fitering 
j=150;
kernel=(1/(2*j+1))*(ones(1,2*j+1));

filtered_sig= zeros(size(signal));

for l=j+1:length(signal)-j-1
  filtered_sig(l)= sum(signal(l-j:l+j).*kernel);
end

%plot the final denoised signal 
figure(3);
plot(1:n, filtered_sig, 1:n, cleanedSignal);

