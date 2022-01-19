%For research purposes, the ECG signals were obtained from the PhysioNet service (http://www.physionet.org) from the MIT-BIH Arrhythmia database. The created database with ECG signals is described below. 1) The ECG signals were from 45 patients: 19 female (age: 23-89) and 26 male (age: 32-89). 2) The ECG signals contained 17 classes: normal sinus rhythm, pacemaker rhythm, and 15 types of cardiac dysfunctions (for each of which at least 10 signal fragments were collected). 3) All ECG signals were recorded at a sampling frequency of 360 [Hz] and a gain of 200 [adu / mV]. 4) For the analysis, 1000, 10-second (3600 samples) fragments of the ECG signal (not overlapping) were randomly selected. 5) Only signals derived from one lead, the MLII, were used. 6) Data are in mat format (Matlab).

clear all;
close all;
clc;
pkg load signal;

%load 3600 samples of nsr sampled at 360hz (10 seconds of data)
load "ecg/1 NSR/113m (1).mat"

nsr=val./1200;
fs=360;
%length of sinus rythm 
len_nsr=size(val,2);
time = 0:1/fs:(1-1/fs);
%plot one nsr waveform
figure(1);
subplot(2,2,1);
plot(time,nsr(1:length(time)));

%window 
windowed_nsr = nsr(1:length(time));
w=hanning(length(time));
w=w';
%windowed_nsr =w.*windowed_nsr;
subplot(2,2,2);
plot(time,windowed_nsr);

%dc blocking filter
filtered_nsr= zeros(size(windowed_nsr));
temp=0;
for m=1:length(windowed_nsr)-1
  filtered_nsr(m)= (windowed_nsr(m+1)-windowed_nsr(m))+ temp;
  temp=filtered_nsr(m);
end


%smoothing filter
k=1;
kernel=(1/(2*k+1))*(ones(1,2*k+1));
filtered_sig= zeros(size(filtered_nsr));
%filtering
for m=k+1:length(filtered_sig)-k-1
  filtered_sig(m)= sum(filtered_nsr(m-k:m+k).*kernel);
end


%high pass filter
k=256;
fc=1.5;
Hp= fir1(k,fc/(fs/2),"high");
filtered_sig=conv(filtered_sig,Hp,"same");
subplot(2,2,2);
plot(time,filtered_sig);

%plot filter kernel 
%N=360;
%hz=-fs/2:(fs/N):fs/2-(fs/N);
%fft_Hp=(1/N)*abs(fftshift(fft(Hp,N)));
%plot(hz,fft_Hp);

%FFT 
N=length(filtered_sig)*4;
hz=-fs/2:(fs/N):fs/2-(fs/N);
fft_nsr=(1/N)*abs(fftshift(fft(filtered_sig,N)));
subplot(2,2,3);
plot(hz,fft_nsr);

#{
%nth difference
diff_sig= zeros(size(filtered_sig));
n=3;
for j=1:n
for m=1:length(filtered_sig)-1
  diff_sig(m)= (filtered_sig(m+1)-filtered_sig(m));
end
filtered_sig=diff_sig;
end
subplot(2,2,4);
plot(time,diff_sig);
#}


%find bpm
threshold=0.1;
peaks_sig= zeros(size(filtered_sig));
for m=2:length(filtered_sig)-1
  if(filtered_sig(m)>filtered_sig(m-1) && filtered_sig(m)>filtered_sig(m+1))
     peaks_sig(m)= filtered_sig(m);
  else
     peaks_sig(m)=0;
    endif
end
subplot(2,2,4);
plot(time,peaks_sig);
%find consequtive positive peaks 
thresholded_peaks_sig= find(peaks_sig>=threshold);

avg_interval=0;
d=0;
for m=1:length(thresholded_peaks_sig)-1
avg_interval = avg_interval+thresholded_peaks_sig(m+1)-thresholded_peaks_sig(m);
d+=1;
endfor
avg_bpm=60/(avg_interval/(d*fs));
