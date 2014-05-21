
Np=100; % prediction horizon
Nc=4;   %control horizon
Gains=[10  0
           0  1];
Ap=[1 2
     3 5]; 
Bp=[0
     1];
Cp=[1 0
     0 1];
Dp=[0
     0];

[nO,nS]=size(Cp);   % [(#outputs) , (#states)]
[nS,nI]=size(Bp);   % [(#states) , (#inputs)]
Aa=eye(nO+nS,nO+nS);  %[(nO+nS) X  (nO+nS)]
Aa(1:nS,1:nS)=Ap; %[(nS) X  (nS)]
Aa(nS+1:nS+nO,1:nS)=Cp*Ap; %[(nO) X  (nS)]

Ba=zeros(nS+nO,nI); %[(nO+nS) X  (nI)]
Ba(1:nS,:)=Bp;%[(nS) X  (nI)]
Ba(nS+1:nS+nO,:)=Cp*Bp;%[(nO) X  (nI)]


Ca=zeros(nO,nS+nO);%[(nO) X  (nS+nO)]
Ca(:,nS+1:nS+nO)=eye(nO,nO);


n=nS+nO;
F=Ca*Aa;
for kk=nO+1:nO:Np*nO
    F(kk:kk+nO-1,:)=F(kk-nO:kk-1,:)*Aa;
end     %F's dim:[Np*(nO) X  (nO+nS)]

h=Ca;%dim:[(nO) X  (nS+nO)]
BarRs=eye(nO);% dim:[(nO) X  (nO)]
for kk=1:Np-1
    h=vertcat(h,Ca*Aa^kk);  %dim:[prev "h" ; [(nO) X  (nS+nO)]]
    BarRs=vertcat(eye(nO),BarRs);  %dim:[[(nO) X  (nO)]; prev "BarRs"]
end
% BarRs's dim:[(Np*nO) X  (nO)]
% h's dim:  [(Np*nO) X  (nS+nO)]

v=h*Ba;% dim:[(Np*nO) X  (nS+nO)] *  [(nO+nS) X  (nI)] = [(Np*nO) X  (nI)]
phi=zeros(Np*nO,Nc*nI); % dim:[(Np*nO) X  (Nc*nI)] 
phi(:,1)=v;
for i=2:Nc
    phi(:,i)=[zeros(nO*(i-1),nI);v(1:Np*nO-(nO*(i-1)),1)];
end  %phi's dim:[(Np*nO) X (Nc*nI)]


Q=zeros(Np*nO,Np*nO);
for i=1:Np
    Q((i-1)*nO+1:i*nO,(i-1)*nO+1:i*nO)=Gains;
end

%Example for F and phi with Np=

%Ca*Aa= [(nO) X  (nS+nO)] * [(nO+nS) X  (nO+nS)]=[(nO) X (nO+nS)]
%Ca*Ba = [(nO) X  (nS+nO)] * [(nO+nS) X  (nI)]=[(nO) X (nI)] 
%Ca*Aa*Ba=[(nO) X (nO+nS)]* [(nO+nS) X  (nI)]=[(nO) X (nI)] 


% F=[Ca*Aa   [(nO)X(nO+nS)]
%     Ca*Aa^2      .
%     Ca*Aa^3      .
%     Ca*Aa^4      .
%     Ca*Aa^5]     [(nO)X(nO+nS)] 
% =>dim:[Np*(nO) X  (nO+nS)]


% phi=[Ca*Ba   0*Ca*Ba    0*Ca*Ba                            %[(nO) X (nI)]   ....(Nc).....    [(nO) X  (nI)]
%     Ca*Aa*Ba   Ca*Ba        0*Ca*Ba                           %...
%     Ca*Aa^2*Ba   Ca*Aa*Ba        Ca*Ba                      %... (Np)
%     Ca*Aa^3*Ba   Ca*Aa^2*Ba        Ca*Aa*Ba             %...
%     Ca*Aa^4*Ba   Ca*Aa^3*Ba        Ca*Aa^2*Ba]         %[(nO) X (nI)]   ....(Nc).....    [(nO) X  (nI)]
% =>dim:[(Np*nO) X (Nc*nI)]

phi_phi=phi'*Q*phi;       % [(Nc*nI) X (Np*nO) ] *[Q]* [(Np*nO) X (Nc*nI)]=[(Nc*nI) X (Nc*nI)]
phi_F=phi'*Q*F;              % [(Nc*nI) X (Np*nO) ] *[Q]* [Np*(nO) X  (nO+nS)]  =[ (Nc*nI) X (nO+nS)]
phi_Q=phi'*Q;               % [(Nc*nI) X (Np*nO)] *[Q]= [ (Nc*nI) X (Np*nO)]






