function [Y,yvalues,f,lambda] = FFTfunct( ts,Fs,plotOrNot )
%FFTfunct Calculates values required for producing the FFT graph
%Inputs
%   ts: y-values in time domain
%   PlotOrNot: boolean, produce plot of FFT at end or not

%Ouputs
%   Y: ouput (FFT values)
%   yvalues: y-values on graph 
%   f: frequncy scale of output
%   lambda: wavelength scale of output

L=length(ts); 
% NFFT = 2^nextpow2(L);
Y  = fft(ts)/L;
f = Fs/2*linspace(0,1,L/2+1);
lambda=3e8./f;
yvalues=abs(Y(1:(L/2+1)));

if plotOrNot
    figure()
    plot(lambda,yvalues) 
    title('Single-Sided Amplitude Spectrum of a(t)')
    xlabel('Wavelength (m)')
    ylabel('|A(f)|')
end

end

