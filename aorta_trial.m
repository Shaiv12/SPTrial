%%Set main folders
defaultFolder = fileparts(fileparts(mfilename('C:\Users\p70068216\Desktop\MATLAB 2018\Installed_MATLAB\bin')));
pathName_FEB=fullfile(defaultFolder); %Where to load the FEB file
pathName_INP=fullfile(defaultFolder); %Where to export the INP file

febFileNamePart='full aorta_job.feb';
febFileName=fullfile(pathName_FEB,febFileNamePart);
[febXML,nodeStruct,elementCell]=import_FEB(febFileName);


%% Plotting the example model surfaces
fontSize=15;
faceAlpha1=0.5;
faceAlpha2=0.5;
edgeColor=0.25*ones(1,3);
edgeWidth=1.5;
markerSize1=50;


hf1=cFigure;
title('Visualizing model','FontSize',fontSize);
xlabel('X','FontSize',fontSize);ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize);
hold on;

uniqueMaterialIndices=[];
for q=1:1:numel(elementCell)
    uniqueMaterialIndices=unique([uniqueMaterialIndices(:); elementCell{q}.E_mat(:)]);
    F=elementCell{q}.E;
    V=nodeStruct.N;
    C=elementCell{q}.E_mat;
%        case {'hex8', 'tet4'}
%             [F,C]=element2faces(elementCell{q}.E,elementCell{q}.E_mat); %Creates faces and colors (e.g. stress) for patch based plotting
%     end
   hp=patch('Faces',F,'Vertices',V,'EdgeColor','k','FaceColor','flat','Cdata',C,'FaceAlpha',0.8);
end

colormap(jet(numel(uniqueMaterialIndices))); hc=colorbar; caxis([min(uniqueMaterialIndices)-0.5 max(uniqueMaterialIndices)+0.5]);
axis equal; view(3); axis tight;  grid on; set(gca,'FontSize',fontSize);
camlight('headlight');
drawnow;

%% You can change this example to do this for material type instead. Just use
%the material indices to select the elements from the lists. However the
%export_INP function can only handle 1 element type at a time at the moment

for q=1:1:numel(elementCell)

    inpFileNamepart=[febFileNamePart(1:end-4),'_',num2str(q),'.inp']; %filename for inp file
    inpFileName=fullfile(pathName_INP,inpFileNamepart);

    elementStruct=elementCell{q};
    %Setting appropriate element type line for ABAQUS. CHECK THESE!      
    elementStruct.E_type='*ELEMENT, TYPE=C3D4, ELSET=PART-DEFAULT_1_EB1';
    export_INP(elementStruct,nodeStruct,inpFileName);
end