function [pcACoor,pcBCoor] = coorProc(pcACoor,pcBCoor,num)
box=max(pcACoor)-min(pcACoor);
V=box(1)*box(2)*box(3);
p1=1/55;
if((num/V)<p1)
    temp=(num/(V*p1))^(1/3);
    pcACoor=pcACoor*temp;
    pcBCoor=pcBCoor*temp;
end

% p2=1/35;
% if((num/V)>p2)
%     temp=(num/(V*p2))^(1/3);
%     pcACoor=pcACoor*temp;
%     pcBCoor=pcBCoor*temp;
% end

pcACoor=round(pcACoor);
pcBCoor=round(pcBCoor);

end