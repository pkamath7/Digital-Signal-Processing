function[Hk] = melfilterbank_func(fs,frame_size,N_FFT,num_mels)
f_start=0;
f_end=fs/2;

%mel configuration
mel_divisor=1/(num_mels+1);

%Find range in mels
mel_start=2595*log10(1+f_start/700);
mel_end=2595*log10(1+f_end/700);

%Divide the mel range into equally spaced monotones
mel_step= (mel_end-mel_start)*(mel_divisor);
mel_points= mel_start:mel_step:mel_end;
f_points = 700*( (10.^(mel_points/2595)) - 1);
f_bins = round(f_points);

%mapping bins to FFT length -fs/2 to +fs/2 maps to N
f_bins = round(f_points*(N_FFT+1)/(fs));

%Monotone inv0ertible mapping from  for visualization
figure(1);
plot(f_points,mel_points);
title("Monotone invertible mapping from linear frequency to mels");
xlabel("frequency(Hz)");
ylabel("quefrency(mels)");

%mel filterbank generation
Hk=zeros(num_mels,frame_size);


%operate on positive frequencies and find the 
%negative frequency response by taking the complex 
%conjugate of the positive part since input signal is real
%matlab indexing starts from 1 
for m=2:num_mels+1
  
  %configure the points for the triangular filterbank
  fbank_start=f_bins(m-1);
  fbank_center=f_bins(m);
  fbank_end=f_bins(m+1);
  
  for n=fbank_start:fbank_center-1
    %upward ramp(positive slope) from start to center
    Hk(m-1,n+1)= (n-fbank_start)/(fbank_center - fbank_start);
  endfor
  
    %downward ramp(negative slope) from center to end  
  for n=fbank_center:fbank_end-1
    Hk(m-1,n+1)= 1+((fbank_center-n)/(fbank_end - fbank_center));
  endfor  
endfor

%mel filter bank plot
figure(2)
f_axis=0:((fs)/N_FFT):fs/2-((fs)/N_FFT);
hold on
for m=1:num_mels
  plot(f_axis,Hk(m,:));
endfor
hold off
title("Mel filter bank");
xlabel("frequency(Hz)");
ylabel("amplitude");

%end of function
end