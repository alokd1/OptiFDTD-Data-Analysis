function [ ts ] = removeReflections2( t_vals,pulse )
%Change1.0
%removeReflections: removes data from any stray reflections
%Inputs
%   t_vals: set of time values extracted from first column of data file (w/ constant time difference)
%   pulse: set of associate pulse amplitude values from second column of data file

%Ouputs
%   ts: time series pulse amplitude values, w/o reflections

%% Note: enter 1/0 for all true/false questions (e.g. "Satisfied... ?")
%%
j=1;
for i=2:(length(pulse)-1)
    if (pulse(i)<=pulse(i+1)&&pulse(i)<=pulse(i-1))||(pulse(i)>=pulse(i+1)&&pulse(i)>=pulse(i-1))
        peak_index(j)=i;
        j=j+1;
    end
end

figure(),plot(t_vals,pulse,'.',t_vals(peak_index),pulse(peak_index),'r.');

%%
m=1;
for i=1:(length(peak_index)-1)
   grad_peaks(m)=(abs(pulse(peak_index(i+1)))-abs(pulse(peak_index(i))))/(t_vals(peak_index(i+1))-t_vals(peak_index(i)));
   m=m+1;
end

figure(),
Y = sign(grad_peaks).*log10(abs(grad_peaks));
plot(t_vals(peak_index(1:length(grad_peaks))),Y,'.')
yl = get(gca,'ytick');
set(gca,'yticklabel',sign(yl).*10.^abs(yl));


%%
i=1;

while (sign(grad_peaks(i))~=-1)
    i=i+1;
    if i>length(grad_peaks)
        break;
    end
end

first_end_index=i; %% Index in grad_peaks where sign(grad_index)=-1 or length(grad_peaks)+1
%%
reflected_start_ind=0;
for i=first_end_index:length(grad_peaks)
    if i==(length(grad_peaks)+1)
       reflected_start_ind=peak_index(i);
       break;
    end
    if sign(grad_peaks(i))==1
       reflected_start_ind=peak_index(i);
       break;
    end
end

%%
%%
ts=pulse(1:reflected_start_ind+1);
figure(),
subplot(1,2,1), plot(t_vals,pulse), title('Original data')
subplot(1,2,2), plot(t_vals(1:reflected_start_ind+1),ts), title('Removed reflections')

cont=input('Continue? ');

while cont==0
    pause(15);
    cont=input('Continue? ');
end

end

