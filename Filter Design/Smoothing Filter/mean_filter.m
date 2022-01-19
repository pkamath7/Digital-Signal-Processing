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

%noise 
noise_amp =0.5;
noise = noise_amp*rand(1,length(signal));
subplot(3,2,2);
plot(1000*time(:,1:2000),noise(:,1:2000));

%Adding noise to signal 
signal_comp= (noise+signal);
subplot(3,2,3);
plot(1000*time(:,1:2000),signal_comp(:,1:2000));


%mean filtering kernel
k=1;
kernel=(1/(2*k+1))*(ones(1,2*k+1));
subplot(3,2,4);
stem(kernel);

filtered_sig= zeros(size(signal));

%filtering
for m=k+1:length(signal)-k-1
  filtered_sig(m)= sum(signal(m-k:m+k).*kernel);
end

subplot(3,2,4);
plot(1000*time(:,1:2000),filtered_sig(:,1:2000));

%soundsc(filtered_sig, srate);