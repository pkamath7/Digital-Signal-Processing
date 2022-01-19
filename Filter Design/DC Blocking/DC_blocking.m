clc;
clear all;
close all;


[signal, srate]=audioread('test.wav'); 
signal = signal';
len= length(signal)/srate;
time = 0: 1/srate : len-1/srate;
figure(1);
subplot(3,2,1);
xlabel('Time (sec.)'), ylabel('Amplitude')
plot(1000*time(:,1:2000),signal(:,1:2000));

%DC offset
amp=1.5
dc=amp.*ones(1,length(signal));
subplot(3,2,2);
plot(1000*time(:,1:2000),dc(:,1:2000));

%Adding noise to signal 
signal_comp= (dc+signal);
subplot(3,2,3);
plot(1000*time(:,1:2000),signal_comp(:,1:2000));

%mean filtering kernel
filtered_sig= zeros(size(signal));

%filtering
temp=0;
for m=1:length(signal)-1
  filtered_sig(m)= (signal(m+1)-signal(m))+ temp;
  temp=filtered_sig(m);
end

subplot(3,2,4);
plot(1000*time(:,1:2000),filtered_sig(:,1:2000));

%soundsc(filtered_sig, srate);