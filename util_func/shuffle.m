function s=shuffle(i,elements)
r=rand(size(i));
[junk,ixes]=sort(r);
s=i(ixes);
if exist('elements','var')
   s=s(elements);
end
