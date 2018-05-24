function [ OSDn ] = normalize_osd( OSD, minOSD, maxOSD )

OSDn = zeros(size(OSD));

for j=1:size(OSDn,2)
%   OSDn(:,j) = (OSD(:,j) - minOSD(j))/(maxOSD(j) - 1); 
   OSDn(:,j) = OSD(:,j)/maxOSD(j); 
end


end

